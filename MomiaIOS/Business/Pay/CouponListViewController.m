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

static NSString *identifierCouponListItemCell = @"CouponListItemCell";

@interface CouponListViewController()
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableArray *couponList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation CouponListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.select = [[params valueForKey:@"select"] boolValue];
        self.oid = [params valueForKey:@"oid"];
        self.status = [params valueForKey:@"status"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.status isEqualToString:@"2"]) {
        self.navigationItem.title = @"已使用红包";
    } else if ([self.status isEqualToString:@"3"]) {
        self.navigationItem.title = @"已过期红包";
    } else {
        self.navigationItem.title = @"我的红包";
    }
    
    if (!self.select) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleGift"] style:UIBarButtonItemStylePlain target:self action:@selector(onGiftClick)];
    }
    
    [CouponListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCouponListItemCell];
    
    self.couponList = [NSMutableArray new];
    [self requestData];
}

- (void)onGiftClick {
    [self openURL:@"duola://share"];
}

- (void)requestData {
    if ([self.couponList count] == 0) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * paramDic = @{@"status":self.status, @"start":[NSString stringWithFormat:@"%ld", (unsigned long)[self.couponList count]], @"count":@"20", @"oid":(self.oid ? self.oid : @"")};
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/coupon")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CouponListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.couponList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     CouponListModel *couponListModel = (CouponListModel *)responseObject;
                                                     self.totalCount = couponListModel.data.totalCount;
                                                     if (self.totalCount == 0) {
                                                         if ([self.status isEqualToString:@"1"]) {
                                                             [self.view showEmptyView:@"您还没有可用红包，\n邀请伙伴加入可以获得更多红包~" tipLogo:[UIImage imageNamed:@"IconEmptyLogo"]];
                                                         } else {
                                                             [self.view showEmptyView:@"还没有红包哟~" tipLogo:[UIImage imageNamed:@"IconEmptyLogo"]];
                                                         }
                                                         return;
                                                     }
                                                     
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

- (void)onExpireClicked {
    [self openURL:@"duola://couponlist?status=3"];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleNone;
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
            cell = itemCell;
        }
        [(CouponListItemCell *)cell setData:[self.couponList objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.couponList.count) {
        return [CouponListItemCell heightWithTableView:tableView withIdentifier:identifierCouponListItemCell forIndexPath:indexPath data:nil];
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.select) {
        return 0.1;
    }
//    if ([self.status isEqualToString:@"1"] && self.totalCount > 0) {
//        return 60;
//    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.select) {
        return nil;
    }
//    if ([self.status isEqualToString:@"1"] && self.totalCount > 0) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//        
//        UIButton *forgetPwBtn = [[UIButton alloc]init];
//        forgetPwBtn.height = 20;
//        forgetPwBtn.width = 80;
//        [forgetPwBtn setTitle:@"过期红包" forState:UIControlStateNormal];
//        forgetPwBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//        forgetPwBtn.left = SCREEN_WIDTH / 2 - 40;
//        forgetPwBtn.top = 15;
//        forgetPwBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [forgetPwBtn setTitleColor:UIColorFromRGB(0x0070C0) forState:UIControlStateNormal];
//        [forgetPwBtn addTarget:self action:@selector(onExpireClicked) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:forgetPwBtn];
//        
//        return view;
//    }
    return nil;
}

@end
