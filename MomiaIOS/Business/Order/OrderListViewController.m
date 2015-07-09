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

@interface OrderListViewController()
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;
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
    if (self.status == 1) {
        self.navigationItem.title = @"待付款订单";
    } else if (self.status == 3) {
        self.navigationItem.title = @"已付款订单";
    }
    self.orderList = [NSMutableArray new];
    [self requestData];
}

- (void)requestData {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *type = self.status == 1 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":[NSString stringWithFormat:@"%d",
                                                        (int)self.orderList.count], @"count":@"20"};
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/order")
                          parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 OrderListModel *orderListModel = (OrderListModel *)responseObject;
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

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order * model = self.orderList[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderdetail?oid=%ld&pid=%ld",[model.ids integerValue],[model.productId integerValue]]];
    
    [[UIApplication sharedApplication] openURL:url];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderList.count < self.totalCount) {
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
            [itemCell setData:[self.orderList objectAtIndex:indexPath.row]];
            cell = itemCell;
        }
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
