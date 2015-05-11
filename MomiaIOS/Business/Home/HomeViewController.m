//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "MineViewController.h"
#import "HomeTopicCell.h"
#import "HomeModel.h"

@interface HomeViewController ()

@property (nonatomic) int startIndex;
@property (nonatomic, strong) HomeModel *model;

- (void)onMineClicked;
- (void)onDiscoverClicked;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"麻麻蜜丫"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(onMineClicked)];
    
    // 设置下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
    // 请求数据
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - title button listener

- (void)onMineClicked {
//    [self.navigationController pushViewController:[[MineViewController alloc]initViewController] animated:true];
    NSURL *url = [NSURL URLWithString:@"momia://mine"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onDiscoverClicked {
    NSLog(@"onDiscoverClicked");
}

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/home?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[HomeModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HomeTopicCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"momia://articletopic"];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model == nil) {
        return 0;
    }
    return [self.model.data.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTopicCell *cell = [HomeTopicCell cellWithTableView:tableView];
    HomeTopic *data = [self.model.data.list objectAtIndex:indexPath.row];
    [cell setData:data];
    return cell;
}

@end
