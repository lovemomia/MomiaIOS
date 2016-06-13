//
//  ReviewListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/6.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ReviewListViewController.h"
#import "ReviewListModel.h"
#import "ReviewListItemCell.h"

static NSString *identifierReviewListItemCell = @"ReviewListItemCell";

@interface ReviewListViewController()

@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSString *subjectId;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation ReviewListViewController

-(instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.courseId = [params objectForKey:@"courseId"];
        self.subjectId = [params objectForKey:@"subjectId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户评价";
    
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    
    self.list = [NSMutableArray new];
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
    }
    
    NSDictionary * paramDic = @{@"id":self.courseId.length > 0 ? self.courseId : self.subjectId, @"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    NSString *path = self.courseId.length > 0 ? @"/course/comment/list" : @"/subject/comment/list";
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[ReviewListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     ReviewListModel *model = (ReviewListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     if (model.data.totalCount == 0) {
                                                         [self.view showEmptyView:@"还没有人点评哦～"];
                                                         return;
                                                     }
                                                     
                                                     for (Review *bs in model.data.list) {
                                                         [self.list addObject:bs];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

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
        ReviewListItemCell * itemCell = [ReviewListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierReviewListItemCell];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.list.count) {
        return 60;
    }
    return [ReviewListItemCell heightWithTableView:tableView withIdentifier:identifierReviewListItemCell forIndexPath:indexPath data:self.list[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}


@end
