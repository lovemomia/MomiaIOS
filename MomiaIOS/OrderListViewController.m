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
#import "OrderListItemFooterCell.h"

#define UserOrderPathURL URL_APPEND_PATH(@"/user/order"

NS_ENUM(NSInteger,RowType){
    RowTypeHeader = 0,
    RowTypeFooter = 1,
};

@interface OrderListViewController()

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray* orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation* curOperation;
@property (nonatomic, strong) OrderListModel* orderListModel;

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
    [self.orderList removeAllObjects];
    if (orderListModel.data.list.count > 0) {
        for (Order *order in orderListModel.data.list) {
            MORowObject *rowHeaderObject = [[MORowObject alloc]init:RowTypeHeader data:order];
            MORowObject *rowFooterObject = [[MORowObject alloc]init:RowTypeFooter data:order];
            MOSectionObject *sectionObject = [[MOSectionObject alloc]init:order.status.integerValue data:@[rowHeaderObject,rowFooterObject]];
            [self.orderList addObject:sectionObject];
        }
    }
    
}

- (void)requestData:(BOOL)refresh {
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
    
    NSString *type = self.status == 2 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":[NSString stringWithFormat:@"%@",self.nextIndex]
                                };
    self.curOperation = [[HttpService defaultService]GET:UserOrderPathURL)
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     self.isLoading = NO;
                                                     [self.view removeLoadingBee];
                                                     self.orderListModel = (OrderListModel *)responseObject;
                                                     self.totalCount = self.orderListModel.data.totalCount;
                                                     if (self.orderListModel.data.nextIndex) {
                                                         self.nextIndex = self.orderListModel.data.nextIndex;
                                                     } else {
                                                         self.nextIndex = [NSNumber numberWithInt:-1];
                                                     }
                                                     [self.tableView reloadData];
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
        MORowObject *rowObject = [self rowInIndexPath:indexPath];;
        Order *order = rowObject.Data;
        [self openURL:[NSString stringWithFormat:@"orderdetail?oid=%@", order.ids]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MORowObject *rowObject = [self rowInIndexPath:indexPath];
    Order *order = rowObject.Data;
    OrderListItemCell *itemCell;
    if (rowObject.Type == RowTypeHeader) {
        
        static NSString *CellOrderListItemHeader = @"CellOrderListItemHeader";
        itemCell = [tableView dequeueReusableCellWithIdentifier:CellOrderListItemHeader];
        if (itemCell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemCell" owner:self options:nil];
            itemCell = [arr objectAtIndex:0];
        }
        [itemCell setData:order];
    } else if (rowObject.Type ==RowTypeFooter) {
        
        static NSString *CellOrderListItemFooter = @"CellOrderListItemFooter";
        itemCell = [tableView dequeueReusableCellWithIdentifier:CellOrderListItemFooter];
        if (itemCell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemCell" owner:self options:nil];
            itemCell = [arr objectAtIndex:1];
        }
        [itemCell setData:order];
    }
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return itemCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MORowObject *rowObject = [self rowInIndexPath:indexPath];
    if (rowObject.Type == RowTypeHeader) {
        return 96;
    }
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (section == self.orderList.count) {
        [view showLoadingBee];
        if(!self.isLoading) {
            [self requestData:NO];
            self.isLoading = YES;
        }
        return view;
    }
    return view;
}

-(MORowObject *)rowInIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    MOSectionObject *sectionObject = self.orderList[section];
    NSArray* array = sectionObject.Data;
    MORowObject *rowObject = array[row];
    return rowObject;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

@end
