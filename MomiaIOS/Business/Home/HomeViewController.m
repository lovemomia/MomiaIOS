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
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeModel.h"

@interface HomeViewController ()

@property (nonatomic) int startIndex;
@property (nonatomic, strong) HomeModel *homeModel;

- (void)onMineClicked;
- (void)onDiscoverClicked;
- (void)onPullDownToRefresh:(UIRefreshControl *)refreshs;

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
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(onPullDownToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
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

#pragma mark - title button listener

- (void)onMineClicked {
//    [self.navigationController pushViewController:[[MineViewController alloc]initViewController] animated:true];
    NSURL *url = [NSURL URLWithString:@"momia://mine"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onDiscoverClicked {
    NSLog(@"onDiscoverClicked");
}

- (void)onPullDownToRefresh:(UIRefreshControl *)refreshs {
//    if (refreshs.refreshing) {
//        refreshs.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
//    }
}

- (void)requestData {
    [self.view showLoadingBee];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://120.55.102.12:8080/home?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.homeModel = [[HomeModel alloc]initWithDictionary:responseObject error:nil];
        [self.tableView reloadData];
        [self.view removeLoadingBee];
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 276;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"momia://articletopic"];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.homeModel == nil) {
        return 0;
    }
    return [self.homeModel.data.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTopicCell *cell = [HomeTopicCell cellWithTableView:tableView];
    HomeTopic *data = [self.homeModel.data.list objectAtIndex:indexPath.row];
    [cell setData:data];
    return cell;
}

@end
