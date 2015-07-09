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

static NSString * identifier = @"CellOrderDetail";
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        height = 100;
    } else if(section == 1) {
        if(row ==0) {
            height = 30;
        } else {
            height = 120;
        }
        
    } else if(section == 2) {
        if(row == 0) {
            height = 30;
        } else {
            height = 60;
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
            UITableViewCell * title = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            title.textLabel.text = @"订单信息";
            cell = title;
        } else {
            OrderDetailMiddleCell * middle = [OrderDetailMiddleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailMiddleIdentifier];
            middle.data = self.model.data;
            cell = middle;
        }
        
    } else if(section == 2) {
        if(row == 0) {
            UITableViewCell * title = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            title.textLabel.text = @"联系人信息";
            cell = title;
        } else {
            OrderDetailBottomCell * bottom = [OrderDetailBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderDetailBottomIdentifier];
            bottom.data = self.model.data;
            cell = bottom;
        }

    }
    return cell;
    
    
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
    
    NSDictionary * dic = @{@"oid":self.oId,@"pid":self.pId};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/user/order/detail") parameters:dic cacheType:CacheTypeNormal JSONModelClass:[OrderDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
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
