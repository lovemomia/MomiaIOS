//
//  OrderDetailController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/25.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailModel.h"
#import "PostOrderModel.h"
#import "OrderListItemCell.h"
#import "CourseSectionTitleCell.h"

static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";

@interface OrderDetailViewController ()

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) OrderDetailModel *model;

@end

@implementation OrderDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.oid = [params objectForKey:@"oid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [OrderListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:@"OrderListItemCell"];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * paramDic = @{@"oid":self.oid};
    NSString *orderDetailURL = URL_APPEND_PATH(@"/subject/order/detail");
    [[HttpService defaultService]GET:orderDetailURL
                          parameters:paramDic
                           cacheType:CacheTypeDisable
                      JSONModelClass:[OrderDetailModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [self.view removeLoadingBee];
                                                     self.model = responseObject;
                                                     [self.tableView reloadData];
                                                 }
                         
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self.view removeLoadingBee];
                                                     [self showDialogWithTitle:nil message:error.message];
                                                 }];
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
    }
    return UIEdgeInsetsMake(0,10,0,0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.model.data.courseId intValue] > 0) {
            [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", self.model.data.courseId]];
            
        } else {
            [self openURL:[NSString stringWithFormat:@"subjectdetail?id=%@", self.model.data.subjectId]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        OrderListItemCell *itemCell = [OrderListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:@"OrderListItemCell"];
        [itemCell setData:self.model.data];
        cell = itemCell;
    }  else if(indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.text = @"订单详情";
            
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = MO_APP_TextColor_gray;
            NSString *text;
            if (indexPath.row == 1) {
                text = [NSString stringWithFormat:@"订单号：%@", self.model.data.ids];
            } else if (indexPath.row == 2) {
                text = [NSString stringWithFormat:@"数量：%@", self.model.data.count];
            } else if (indexPath.row == 3) {
                text = [NSString stringWithFormat:@"总价：%@", self.model.data.totalFee];
            } else if (indexPath.row == 4 && self.model.data.couponDesc.length > 0) {
                text = [NSString stringWithFormat:@"使用抵扣：%@", self.model.data.couponDesc];
            } else {
                text = [NSString stringWithFormat:@"下单时间：%@", self.model.data.addTime];
            }
            cell.textLabel.text = text;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

@end
