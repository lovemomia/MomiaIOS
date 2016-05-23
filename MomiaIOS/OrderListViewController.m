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
#import "PostOrderModel.h"

#define UserOrderPathURL URL_APPEND_PATH(@"/user/order"

@interface OrderListViewController()

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray* orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation* curOperation;
@property (nonatomic, strong) OrderListModel* orderListModel;
@property (nonatomic, assign) BOOL isRefresh;  //YES:刷新,NO:翻页

@end

@implementation OrderListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        [self decodeParams:params];
    }
    return self;
}

-(void)decodeParams:(NSDictionary *)params{
    self.status = [[params valueForKey:@"status"] integerValue];
    if (self.status == 2) {
        self.navigationItem.title = @"待付款订单";
    } else if (self.status == 3) {
        self.navigationItem.title = @"已付款订单";
    } else {
        self.navigationItem.title = @"全部订单";
    }
}

-(NSMutableArray *)orderList{
    if (_orderList == nil) {
        _orderList = [[NSMutableArray alloc]init];
    }
    return _orderList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderList) name:@"updateOrderList" object:nil];
    [OrderListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:@"OrderListItemCell"];
    [self requestData:YES];
}

-(void)updateOrderList {
    [self requestData:YES];
}

-(void)setOrderListModel:(OrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    if (!orderListModel) {
        return;
    }
    if (self.isRefresh) { //刷新
        [self.orderList removeAllObjects];
        if (orderListModel.data.list.count > 0) {
            for (Order *order in orderListModel.data.list) {
                [self.orderList addObject:order];
            }
        }
    } else {
        [self.orderList addObjectsFromArray:orderListModel.data.list];
    }
}

//refresh YES:刷新 NO:翻页
- (void)requestData:(BOOL)refresh {
    
    self.isRefresh = refresh;
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.orderList count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = [NSNumber numberWithInt:0];
        self.isLoading = NO;
        [self.view removeEmptyView];
    }
    self.isLoading = YES;
    NSString *type = self.status == 2 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":[NSString stringWithFormat:@"%@",self.nextIndex]
                                };
    self.curOperation = [[HttpService defaultService]GET:UserOrderPathURL)
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     self.isLoading = NO;
                                                     self.orderListModel = (OrderListModel *)responseObject;
                                                     self.totalCount = self.orderListModel.data.totalCount;
                                                     self.nextIndex = self.orderListModel.data.nextIndex;
                                                     if (self.orderListModel.data.totalCount == 0) {
                                                         if (self.status == 2) {
                                                             [self.view showEmptyView:@"您还没有待付款订单哦，\n快去逛一下吧~"];
                                                         } else if (self.status == 3) {
                                                             [self.view showEmptyView:@"您还没有已付款订单哦，\n快去逛一下吧~"];
                                                         } else {
                                                             [self.view showEmptyView:@"订单列表为空"];
                                                         }
                                                         return;
                                                     }
                                                     [self.view removeLoadingBee];
                                                     [self.tableView reloadData];
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
        Order *order = [self.orderList objectAtIndex:indexPath.row];
        [self openURL:[NSString stringWithFormat:@"orderdetail?oid=%@", order.ids]];
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
    
    UITableViewCell *cell;
    if(indexPath.row == self.orderList.count) {
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
        Order *order = [self.orderList objectAtIndex:indexPath.row];
        OrderListItemCell *itemCell = [OrderListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:@"OrderListItemCell"];
        [itemCell setData:order];
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

@end
