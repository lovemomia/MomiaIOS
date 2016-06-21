//
//  CommentListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CommentListViewController.h"
#import "FeedCommentCell.h"
#import "FeedCommentListModel.h"
#import "AddCommentViewController.h"
#import "MONavigationController.h"
#import "MJRefreshHelper.h"

static NSString *identifierFeedCommentCell = @"FeedCommentCell";

@interface CommentListViewController()
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation CommentListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表评论" style:UIBarButtonItemStylePlain target:self action:@selector(onCommentClicked)];
    
    [FeedCommentCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierFeedCommentCell];
    
    self.list = [NSMutableArray new];
    
    // 设置下拉刷新
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData:YES];
}

- (void)onCommentClicked {
    if (![[AccountService defaultService] isLogin]) {
        [[AccountService defaultService] login:self success:nil];
        return;
    }
    
    NSDictionary * dic = @{@"id":self.ids};
    AddCommentViewController *controller = [[AddCommentViewController alloc]initWithParams:dic];
    
    controller.successBlock = ^(){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self requestData:YES];
    };
    controller.cancelBlock = ^(){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)requestData {
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.list count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = 0;
        self.isLoading = NO;
        [self.view removeEmptyView];
    }
    
    NSDictionary * paramDic = @{@"id":self.ids, @"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/feed/comment")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[FeedCommentListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     FeedCommentListModel *model = (FeedCommentListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (model.data.totalCount == 0) {
                                                         [self.view showEmptyView:@"还没有人评论，快来抢沙发哟~"];
                                                         return;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     for (FeedComment *comment in model.data.list) {
                                                         [self.list addObject:comment];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                     
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex > 0) {
        return self.list.count + 1;
    }
    return self.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.list.count) {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData:NO];
            self.isLoading = YES;
        }
        
    } else {
        FeedCommentCell * itemCell = [FeedCommentCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedCommentCell];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.list.count) {
        FeedComment *comment = [self.list objectAtIndex:(indexPath.row)];
        return [FeedCommentCell heightWithTableView:tableView withIdentifier:identifierFeedCommentCell forIndexPath:indexPath data:comment];
    }
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
