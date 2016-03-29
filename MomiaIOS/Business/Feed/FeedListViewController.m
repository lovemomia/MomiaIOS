//
//  PlaymateViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedListViewController.h"

#import "FeedUserHeadCell.h"
#import "FeedUgcCell.h"
#import "FeedContentCell.h"
#import "FeedSuggestHeadCell.h"
#import "FeedSuggestUserCell.h"
#import "FeedListModel.h"
#import "MJRefreshHelper.h"

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierPlaymateUgcCell = @"PlaymateUgcCell";
static NSString *identifierPlaymateSuggestHeadCell = @"PlaymateSuggestHeadCell";
static NSString *identifierPlaymateSuggestUserCell = @"PlaymateSuggestUserCell";

@interface FeedListViewController()<FeedUgcCellDelegate>

@property(nonatomic,strong) NSMutableDictionary * contentCellHeightCacheDic;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@property (nonatomic, assign) NSInteger openIndex;

@end

@implementation FeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"成长说";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleCamera"] style:UIBarButtonItemStylePlain target:self action:@selector(onAddFeedClick)];
    
    [FeedUserHeadCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [FeedUgcCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateUgcCell];
    [FeedSuggestHeadCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateSuggestHeadCell];
    [FeedSuggestUserCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateSuggestUserCell];
    
    // 设置下拉刷新
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.list = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData:true];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataChanged:) name:@"onDataChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onZanChanged:) name:@"onZanChanged" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onZanChanged" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onDataChanged" object:nil];
}

- (void)onDataChanged:(NSNotification*)notify {
    [self.tableView.mj_header beginRefreshing];
}

-(void)onZanChanged:(NSNotification *)note {
    Feed *feed = [self.list objectAtIndex:self.openIndex];
    BOOL curStared = [feed.stared boolValue];
    BOOL isStared = [[note.userInfo objectForKey:@"isStared"] boolValue];
    if (curStared == isStared) {
        return;
    }
    feed.stared = [note.userInfo objectForKey:@"isStared"];
    if (isStared) {
        feed.starCount = [NSNumber numberWithInt:([feed.starCount intValue] + 1)];
    } else {
        feed.starCount = [NSNumber numberWithInt:([feed.starCount intValue] - 1)];
    }
    [self.tableView reloadData];
}

- (void)onAddFeedClick {
    [self openURL:@"addfeed"];
    
    [MobClick event:@"Feed_Title_Add"];
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
        self.nextIndex = [NSNumber numberWithInt:0];
        self.isLoading = NO;
        [self.view removeEmptyView];
    }
    
    NSDictionary * paramDic = @{@"start":[NSString stringWithFormat:@"%@", self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/feed")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[FeedListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [self.tableView.mj_header endRefreshing];
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     FeedListModel *model = (FeedListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = model.data.nextIndex;
                                                     } else {
                                                         self.nextIndex = [NSNumber numberWithInt:-1];
                                                     }
                                                     
                                                     if ([model.data.totalCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                         [self.view showEmptyView:@"关注玩伴可以看到更多内容~"];
                                                         return;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     for (Feed *feed in model.data.list) {
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
                                                     [self.tableView.mj_header endRefreshing];
                                                 }];
}

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
        [self openURL:[NSString stringWithFormat:@"feeddetail?id=%@", feed.ids]];
        self.openIndex = indexPath.section;
        
        NSDictionary *attributes = @{@"index":[NSString stringWithFormat:@"%d", (int)indexPath.section]};
        [MobClick event:@"Feed_List" attributes:attributes];
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
        if ([feed.type intValue] == 1) {
            if (indexPath.row == 0) {
                return [FeedUserHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateUserHeadCell forIndexPath:indexPath data:feed];
            } else if (indexPath.row == 2) {
                return [FeedUgcCell heightWithTableView:tableView withIdentifier:identifierPlaymateUgcCell forIndexPath:indexPath data:feed];
            } else {
                return [FeedContentCell heightWithTableView:tableView contentModel:feed];
            }
        } else {
            if (indexPath.row == 0) {
                return [FeedSuggestHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateSuggestHeadCell forIndexPath:indexPath data:nil];
            } else {
                return [FeedSuggestUserCell heightWithTableView:tableView withIdentifier:identifierPlaymateSuggestUserCell forIndexPath:indexPath data:nil];
            }
        }
    }
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
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
    if ([feed.type intValue] == 1) {
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
        
    } else {
        if (indexPath.row == 0) {
            FeedSuggestHeadCell *headCell = [FeedSuggestHeadCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateSuggestHeadCell];
            [headCell setData:@""];
            cell = headCell;
        } else {
            FeedSuggestUserCell *userCell = [FeedSuggestUserCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateSuggestUserCell];
            [userCell setData:@""];
            cell = userCell;
        }
        return cell;
    }
}

#pragma mark - FeedUgcCell delegate

- (void)onCommentClicked:(id)cell {
    FeedUgcCell *ugcCell = cell;
    Feed *feed = [self.list objectAtIndex:ugcCell.tag];
    [self openURL:[NSString stringWithFormat:@"commentlist?id=%@", feed.ids]];
}

- (void)onZanClicked:(id)cell {
    if (![[AccountService defaultService] isLogin]) {
        [[AccountService defaultService] login:self success:nil];
        return;
    }
    
    FeedUgcCell *ugcCell = cell;
    Feed *feed = [self.list objectAtIndex:ugcCell.tag];
    NSDictionary * dic = @{@"id":feed.ids};
    BOOL isStared = [feed.stared boolValue];
    NSString *path = isStared ? @"/feed/unstar" : @"/feed/star";
    [[HttpService defaultService] POST:URL_APPEND_PATH(path) parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        feed.stared = [NSNumber numberWithBool:!isStared];
        feed.starCount = [NSNumber numberWithInt:(isStared ? ([feed.starCount intValue] - 1) : ([feed.starCount intValue] + 1))];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
