//
//  OrderListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/5.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListModel.h"
#import "OrderListItemCell.h"
#import "PostPersonModel.h"

@interface OrderListViewController()
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation OrderListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.status = [[params valueForKey:@"status"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.status == 2) {
        self.navigationItem.title = @"待付款订单";
    } else if (self.status == 3) {
        self.navigationItem.title = @"已付款订单";
    } else {
        self.navigationItem.title = @"全部订单";
    }
    self.orderList = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData];
}


- (void)refreshData {
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"start":@"0", @"count":@"20"};
   self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/order")
                          parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 //                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 OrderListModel *orderListModel = (OrderListModel *)responseObject;
                                 self.totalCount = orderListModel.data.totalCount;
                                 self.nextIndex = orderListModel.data.nextIndex;
                                 if (self.totalCount == 0) {
                                     if (self.status == 2) {
                                         [self.view showEmptyView:@"您还没有待付款订单哦，\n快去逛一下吧~"];
                                     } else if (self.status == 3) {
                                         [self.view showEmptyView:@"您还没有已付款订单哦，\n快去逛一下吧~"];
                                     } else {
                                         [self.view showEmptyView:@"订单列表为空"];
                                     }
                                     return;
                                 }
                                 
                                 [self.orderList removeAllObjects];
                                 
                                 for (Order *order in orderListModel.data.list) {
                                     [self.orderList addObject:order];
                                 }
                                 [self.tableView reloadData];
                                 self.isLoading = NO;
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 //                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [self showDialogWithTitle:nil message:error.message];
                                 self.isLoading = NO;
                             }];
}



- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.orderList count] == 0) {
        [self.view showLoadingBee];
    }
    
    NSString *type = self.status == 2 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":[NSString stringWithFormat:@"%d",
                                                        [self.nextIndex intValue]], @"count":@"20"};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/order")
                          parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if ([self.orderList count] == 0) {
                                     [self.view removeLoadingBee];
                                 }
                                 
                                 OrderListModel *orderListModel = (OrderListModel *)responseObject;
                                 self.totalCount = orderListModel.data.totalCount;
                                 self.nextIndex = orderListModel.data.nextIndex;
                                 if (self.totalCount == 0) {
                                     if (self.status == 2) {
                                         [self.view showEmptyView:@"您还没有待付款订单哦，快去逛一下吧~"];
                                     } else if (self.status == 3) {
                                         [self.view showEmptyView:@"您还没有已付款订单哦，快去逛一下吧~"];
                                     } else {
                                         [self.view showEmptyView:@"订单列表为空"];
                                     }
                                     return;
                                 }
                                 
                                 for (Order *order in orderListModel.data.list) {
                                     [self.orderList addObject:order];
                                 }
                                 [self.tableView reloadData];
                                 self.isLoading = NO;
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self showDialogWithTitle:nil message:error.message];
                                 self.isLoading = NO;
                             }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.orderList.count) {
        Order * model = self.orderList[indexPath.row];
        [self openURL:[NSString stringWithFormat:@"orderdetail?oid=%@", model.ids]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex && self.nextIndex > 0) {
        return self.orderList.count + 1;
    }
    return self.orderList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.orderList.count) {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData];
            self.isLoading = YES;
        }
        
    } else {
        static NSString *Cell_Order_List_Item = @"Cell_Order_List_Item";
        cell = [tableView dequeueReusableCellWithIdentifier:Cell_Order_List_Item];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemCell" owner:self options:nil];
            OrderListItemCell *itemCell = [arr objectAtIndex:0];
            cell = itemCell;
        }
        [(OrderListItemCell *)cell setData:[self.orderList objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
