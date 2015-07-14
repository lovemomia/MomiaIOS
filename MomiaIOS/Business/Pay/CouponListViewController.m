//
//  CouponListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CouponListViewController.h"

#import "CouponListItemCell.h"
#import "Coupon.h"
#import "CouponListModel.h"

@interface CouponListViewController()
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSMutableArray *couponList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation CouponListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.select = [[params valueForKey:@"select"] boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的红包";
    self.couponList = [NSMutableArray new];
    [self requestData];
}

- (void)requestData {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * paramDic = @{@"status":@"0", @"start":@"0", @"count":@"20"};
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/coupon")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CouponListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     //                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     CouponListModel *couponListModel = (CouponListModel *)responseObject;
                                                     self.totalCount = couponListModel.data.totalCount;
                                                     
                                                     [self.couponList removeAllObjects];
                                                     
                                                     for (Coupon *coupon in couponListModel.data.list) {
                                                         [self.couponList addObject:coupon];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.select && indexPath.row < self.couponList.count) {
        
        Coupon * model = self.couponList[indexPath.row];
        if (model.status == 1 && self.selectCouponBlock) {
            self.selectCouponBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.couponList.count < self.totalCount) {
        return self.couponList.count + 1;
    }
    return self.couponList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.couponList.count) {
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
        static NSString *Cell_Order_List_Item = @"Cell_Coupon_List_Item";
        cell = [tableView dequeueReusableCellWithIdentifier:Cell_Order_List_Item];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CouponListItemCell" owner:self options:nil];
            CouponListItemCell *itemCell = [arr objectAtIndex:0];
            [itemCell setData:[self.couponList objectAtIndex:indexPath.row]];
            cell = itemCell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
