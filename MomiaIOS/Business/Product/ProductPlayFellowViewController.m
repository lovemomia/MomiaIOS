//
//  ProductPlayFellowViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductPlayFellowViewController.h"
#import "PlayFellowModel.h"
#import "ProductPlayFellowHeaderView.h"
#import "ProductPlayFellowCell.h"

static NSString * p_p_f_identifier = @"Cell_p_p_f";

@interface ProductPlayFellowViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString * productId;
@property (nonatomic,strong) PlayFellowModel * model;
@end

@implementation ProductPlayFellowViewController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    ProductPlayFellowCell * cell = [ProductPlayFellowCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:p_p_f_identifier];
    PlayFellowListModel * listModel = self.model.data.list[section];
    PlayFellowCustomersModel * customersModel = listModel.customers[row];
    [cell setData:customersModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PlayFellowListModel * model = self.model.data.list[section];
    if([model.selected boolValue]) {//表明被选中了，需要弹出玩伴孩童列表信息
        return model.customers.count;
    } else {
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.data.list.count;//返回场次的数目
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 63;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductPlayFellowHeaderView * headerView = [ProductPlayFellowHeaderView headerWithTableView:self.tableView];
    [headerView setData:self.model.data.list[section]];
    headerView.onClickHeaderBlock = ^(UITapGestureRecognizer * tapGesture) {
        PlayFellowListModel * listModel = self.model.data.list[section];
        if([listModel.selected boolValue]) {
            listModel.selected = [NSNumber numberWithBool:NO];
        } else {
            listModel.selected = [NSNumber numberWithBool:YES];
        }
        [self.tableView reloadData];
    };
    return headerView;
}

#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"id":self.productId};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product/playmates") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[PlayFellowModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        //下边一个迭代操作是初始化所有的header为未选中状态
        for(PlayFellowListModel * model in self.model.data.list) {
            model.selected = [NSNumber numberWithBool:NO];
        }
                
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.productId = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"玩伴信息";
    
    [ProductPlayFellowHeaderView registerHeaderWithTableView:self.tableView];
    [ProductPlayFellowCell registerCellWithTableView:self.tableView withIdentifier:p_p_f_identifier];
    
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
