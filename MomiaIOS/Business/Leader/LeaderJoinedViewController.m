//
//  LeaderJoinedViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LeaderJoinedViewController.h"
#import "LeaderJoinedCell.h"
#import "LeaderStatusModel.h"
#import "LeaderProductModel.h"

static NSString * leaderJoinedCellIdentifier = @"LeaderJoinedCell";

@interface LeaderJoinedViewController ()
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;
@end

@implementation LeaderJoinedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动列表";
    
    [LeaderJoinedCell registerCellWithTableView:self.tableView withIdentifier:leaderJoinedCellIdentifier];
}

- (void)setModel:(LeaderStatusModel *)model {
    _model = model;
    
    self.list = [[NSMutableArray alloc]initWithArray:model.data.products.list];
    self.nextIndex = [model.data.products.nextIndex integerValue];
    [self.tableView reloadData];
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
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/leader/product")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[LeaderProductModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     LeaderProductModel *orderListModel = (LeaderProductModel *)responseObject;
                                                     self.nextIndex = [orderListModel.data.nextIndex integerValue];
                                                     if (orderListModel.data.totalCount == 0) {
                                                         [self.view showEmptyView:@"您还没有认领活动，快来成为领队赚取红包吧~"];
                                                         return;
                                                     }
                                                     
                                                     for (ProductModel *order in orderListModel.data.list) {
                                                         [self.list addObject:order];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.list.count) {
        ProductModel *product;
        product = self.list[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://productdetail?id=%ld", (long)product.pID]];
        [[UIApplication sharedApplication] openURL:url];
    }
    
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
        LeaderJoinedCell * itemCell = [LeaderJoinedCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:leaderJoinedCellIdentifier];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
