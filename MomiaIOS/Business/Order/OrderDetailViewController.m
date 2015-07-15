//
//  OrderDetailViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailModel.h"
#import "OrderDetailTopCell.h"
#import "OrderDetailMiddleCell.h"
#import "OrderDetailBottomCell.h"
#import "OrderDetailTitleCell.h"
#import "PostOrderModel.h"

static NSString * orderDetailTitleIdentifier = @"CellOrderDetailTitle";
static NSString * orderDetailTopIdentifier = @"CellOrderDetailTop";
static NSString * orderDetailMiddleIdentifier = @"CellOrderDetailMiddle";
static NSString * orderDetailBottomIdentifier = @"CellOrderDetailBottom";

@interface OrderDetailViewController ()

@property(nonatomic,strong) OrderDetailModel * model;
@property(nonatomic,strong) NSString * oId;
@property(nonatomic,strong) NSString * pId;

@end

@implementation OrderDetailViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model)
        return 3;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return 2;
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2 && self.model.data.status <= 2 && self.model.data.status > 0) {
        return 80.0f;
    } else {
        return 10.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        height = 102;
    } else if(section == 1) {
        if(row ==0) {
            height = 40;
        } else {
            height = 126;
        }
        
    } else if(section == 2) {
        if(row == 0) {
            height = 40;
        } else {
            height = 57;
        }
    }
    return height;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    
    if(section == 0) {
        OrderDetailTopCell * top = [OrderDetailTopCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailTopIdentifier];
        top.data = self.model.data;
        cell = top;
    } else if(section == 1) {
        if(row == 0) {
            OrderDetailTitleCell * title = [OrderDetailTitleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailTitleIdentifier];
            title.data = @"订单信息";
            cell = title;
        } else {
            OrderDetailMiddleCell * middle = [OrderDetailMiddleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailMiddleIdentifier];
            middle.data = self.model.data;
            cell = middle;
        }
        
    } else if(section == 2) {
        if(row == 0) {
            OrderDetailTitleCell * title = [OrderDetailTitleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailTitleIdentifier];
            title.data = @"联系人信息";
            cell = title;
        } else {
            OrderDetailBottomCell * bottom = [OrderDetailBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailBottomIdentifier];
            bottom.data = self.model.data;
            cell = bottom;
        }

    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        if(row == 0) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://productdetail?id=%@",self.pId]];
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1 && self.model.data.status <= 2 && self.model.data.status > 0) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onPayClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"cm_large_button_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"cm_large_button_disable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

-(void)onPayClicked:(id) sender
{
    PostOrderModel * model = [[PostOrderModel alloc] init];
    PostOrderData * data = [[PostOrderData alloc] init];
    data.count = self.model.data.count;
    data.orderId = self.model.data.orderNo;
    data.participants = self.model.data.participants;
    data.productId = self.model.data.productId;
    data.skuId = self.model.data.skuId;
    data.totalFee = self.model.data.totalFee;
    
    model.errMsg = self.model.errMsg;
    model.errNo = self.model.errNo;
    model.timestamp = self.model.timestamp;
    model.data = data;

    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://cashpay?pom=%@",
                                        [[model toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];

}




- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    NSLog(@"%@",[AccountService defaultService].account.token);
    NSDictionary * dic = @{@"oid":self.oId,@"pid":self.pId};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/user/order/detail") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[OrderDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}

-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.oId = [params objectForKey:@"oid"];
        self.pId = [params objectForKey:@"pid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的订单";
    
    [OrderDetailTitleCell registerCellWithTableView:self.tableView withIdentifier:orderDetailTitleIdentifier];
    [OrderDetailTopCell registerCellWithTableView:self.tableView withIdentifier:orderDetailTopIdentifier];
    [OrderDetailMiddleCell registerCellWithTableView:self.tableView withIdentifier:orderDetailMiddleIdentifier];
    [OrderDetailBottomCell registerCellWithTableView:self.tableView withIdentifier:orderDetailBottomIdentifier];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
