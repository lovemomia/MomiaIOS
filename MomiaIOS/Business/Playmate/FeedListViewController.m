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

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierPlaymateUgcCell = @"PlaymateUgcCell";
static NSString *identifierPlaymateSuggestHeadCell = @"PlaymateSuggestHeadCell";
static NSString *identifierPlaymateSuggestUserCell = @"PlaymateSuggestUserCell";

@interface FeedListViewController()

@property(nonatomic,strong) NSMutableDictionary * contentCellHeightCacheDic;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation FeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"玩伴";
    
    [FeedUserHeadCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [FeedUgcCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateUgcCell];
    [FeedSuggestHeadCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateSuggestHeadCell];
    [FeedSuggestUserCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateSuggestUserCell];
    
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
        self.nextIndex = 0;
        [self.list removeAllObjects];
        self.isLoading = NO;
    }
    
    NSDictionary * paramDic = @{@"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/feed")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[FeedListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self openURL:@"duola://feeddetail"];
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

@end
