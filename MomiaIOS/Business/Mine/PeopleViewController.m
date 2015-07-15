//
//  PeopleViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PeopleViewController.h"
#import "OrderPersonViewController.h"
#import "OrderPersonCell.h"
#import "CommonHeaderView.h"
#import "OrderPerson.h"
#import "PostPersonModel.h"
#import "MJRefresh.h"
#import "OrderPersonModel.h"


static NSString * orderPersonIdentifier = @"CellOrderPerson";

@interface PeopleViewController ()

@property (nonatomic, strong) OrderPersonModel * model;

@end

@implementation PeopleViewController

#pragma tableView dataSource&delegate

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //执行删除联系人操作
        [self deletePerson:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) return 1;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPersonCell * cell = [OrderPersonCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:orderPersonIdentifier];
    OrderPerson *dataModel = self.model.data[indexPath.row];
    [cell setData:dataModel withSelectedDic:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.onEditBlock = ^(UIButton * editBtn) {
        //开始编辑出行人
        OrderPerson * model = self.model.data[indexPath.row];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderupdateperson?personId=%ld",model.opId]];
        [[UIApplication sharedApplication] openURL:url];
        
    };
    return cell;
}

-(void)onNewAddClick
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderupdateperson"]];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - webData Request

-(void)deletePerson:(NSIndexPath *) indexPath
{
    OrderPerson * dataModel = self.model.data[indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"id":@(dataModel.opId)};
    
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/participant/delete")
                           parameters:params
                       JSONModelClass:[PostPersonModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  [self requestData];
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
    
    
}




- (void)requestData {
    self.model = nil;
    [self.tableView reloadData];
    
    [self.view showLoadingBee];
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/participant/list") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[OrderPersonModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - view life cycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePersonSuccess" object:nil];
}

//-(instancetype)initWithParams:(NSDictionary *)params
//{
//    self = [super initWithParams:params];
//    if(self) {
//        self.utoken = [params objectForKey:@"utoken"];
//        PersonStyle personStyle;
//        personStyle.adult = [(NSString *)[params objectForKey:@"adult"] integerValue];
//        personStyle.child = [(NSString *)[params objectForKey:@"child"] integerValue];
//        self.personStyle = personStyle;
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"常用出行人";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onNewAddClick)];
    
    [CommonHeaderView registerCellWithTableView:self.tableView];
    
    [OrderPersonCell registerCellWithTableView:self.tableView withIdentifier:orderPersonIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePersonSuccess)
                                                 name:@"updatePersonSuccess"
                                               object:nil];
}

-(void)updatePersonSuccess
{
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
