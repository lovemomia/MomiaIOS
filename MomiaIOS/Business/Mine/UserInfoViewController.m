//
//  ThirdPersonViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/11.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoHeaderView.h"
#import "UserInfoModel.h"

#import "FeedUserHeadCell.h"
#import "FeedUgcCell.h"
#import "FeedContentCell.h"

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierPlaymateUgcCell = @"PlaymateUgcCell";

@interface UserInfoViewController ()<FeedUgcCellDelegate>

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, assign) BOOL isMe;

@property(nonatomic,strong) NSMutableDictionary * contentCellHeightCacheDic;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation UserInfoViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.uid = [params objectForKey:@"uid"];
        self.isMe = [[params objectForKey:@"me"]boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.isMe ? @"成长说" : @"Ta的";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [FeedUserHeadCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [FeedUgcCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateUgcCell];
    
    self.list = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData:true];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.list count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = [NSNumber numberWithInt:0];
        self.isLoading = NO;
        [self.view removeEmptyView];
    }
    
    NSDictionary * paramDic = @{@"uid":self.uid, @"start":[NSString stringWithFormat:@"%@", self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/info")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[UserInfoModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     UserInfoModel *model = (UserInfoModel *)responseObject;
                                                     if (model.data.feeds.nextIndex) {
                                                         self.nextIndex = model.data.feeds.nextIndex;
                                                     } else {
                                                         self.nextIndex = [NSNumber numberWithInt:-1];
                                                     }
                                                     
                                                     if (model.data.user) {
                                                         self.user = model.data.user;
                                                     }
                                                     
                                                     if ([model.data.feeds.totalCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                         [self.view showEmptyView:@"Ta还没有成长说哦~"];
                                                         return;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     for (Feed *feed in model.data.feeds.list) {
                                                         [self.list addObject:feed];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNavTransparent {
    return NO;
}

- (BOOL)isNavDarkStyle {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,65,0,0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.list.count) {
        Feed *feed = [self.list objectAtIndex:indexPath.section];
        [self openURL:[NSString stringWithFormat:@"duola://feeddetail?id=%@", feed.ids]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.nextIndex && [self.nextIndex intValue] > 0) {
        return self.list.count + 1;
    }
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.list.count) {
        Feed *feed = [self.list objectAtIndex:section];
        if ([feed.type intValue] == 1) {
            return 3;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.list.count) {
        Feed *feed = [self.list objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            return [FeedUserHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateUserHeadCell forIndexPath:indexPath data:feed];
        } else if (indexPath.row == 2) {
            return [FeedUgcCell heightWithTableView:tableView withIdentifier:identifierPlaymateUgcCell forIndexPath:indexPath data:feed];
        } else {
            return [FeedContentCell heightWithTableView:tableView contentModel:feed];
        }
    }
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCREEN_WIDTH * 2 / 3;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView" owner:self options:nil];
        UserInfoHeaderView *headerView = [arr objectAtIndex:0];
        [headerView setData:self.user];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.list.count) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (section == self.list.count) {
        [view showLoadingBee];
        if(!self.isLoading) {
            [self requestData:false];
            self.isLoading = YES;
        }
        return view;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    Feed *feed = [self.list objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        FeedUserHeadCell *userHeadCell = [FeedUserHeadCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUserHeadCell];
        [userHeadCell setData:feed];
        cell = userHeadCell;
        
    } else if (indexPath.row == 1) {
        FeedContentCell *contentCell = [[FeedContentCell alloc]initWithTableView:tableView contentModel:feed];
        cell = contentCell;
        
    } else {
        FeedUgcCell *ugcCell = [FeedUgcCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUgcCell];
        [ugcCell setData:feed];
        ugcCell.delegate = self;
        ugcCell.tag = indexPath.section;
        cell = ugcCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - FeedUgcCell delegate

- (void)onCommentClicked:(id)cell {
    FeedUgcCell *ugcCell = cell;
    Feed *feed = [self.list objectAtIndex:ugcCell.tag];
    [self openURL:[NSString stringWithFormat:@"duola://commentlist?id=%@", feed.ids]];
}

- (void)onZanClicked:(id)cell {
    FeedUgcCell *ugcCell = cell;
    Feed *feed = [self.list objectAtIndex:ugcCell.tag];
    if (![[AccountService defaultService] isLogin]) {
        [[AccountService defaultService] login:self];
    }
    NSDictionary * dic = @{@"id":feed.ids};
    [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feed/star") parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        feed.stared = [NSNumber numberWithBool:YES];
        feed.starCount = [NSNumber numberWithInt:([feed.starCount intValue] + 1)];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end
