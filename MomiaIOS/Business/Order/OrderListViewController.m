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
#import "MOTabHost.h"

@interface OrderListViewController()
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;
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
    [self requestData];
}

-(void)deleteOrder:(NSIndexPath *) indexPath
{
    Order * model = self.orderList[indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"id":model.ids};
    
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/order/delete")
                           parameters:params
                       JSONModelClass:[PostPersonModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  [self refreshData];
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
    
    
}


- (void)refreshData {
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSString *type = self.status == 2 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":@"0", @"count":@"20"};
   self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/order")
                          parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 //                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 OrderListModel *orderListModel = (OrderListModel *)responseObject;
                                 self.totalCount = orderListModel.data.totalCount;
                                 
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.orderList count] == 0) {
        [self.view showLoadingBee];
    }
    
    NSString *type = self.status == 2 ? @"le" : @"ge";
    NSDictionary * paramDic = @{@"status":[NSString stringWithFormat:@"%d", (int)self.status],
                                @"type":type, @"start":[NSString stringWithFormat:@"%d",
                                                        (int)self.orderList.count], @"count":@"20"};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/order")
                          parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[OrderListModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 OrderListModel *orderListModel = (OrderListModel *)responseObject;
                                 self.totalCount = orderListModel.data.totalCount;
                                 
                                 if ([self.orderList count] == 0) {
                                     [self.view removeLoadingBee];
                                 }
                                 
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.status == 2 && indexPath.row < self.orderList.count) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //执行删除联系人操作
        [self deleteOrder:indexPath];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.orderList.count) {
        
        Order * model = self.orderList[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderdetail?oid=%ld&pid=%ld",(long)[model.ids integerValue],(long)[model.productId integerValue]]];
        
        [[UIApplication sharedApplication] openURL:url];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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
