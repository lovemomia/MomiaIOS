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

@property (nonatomic) NSInteger startIndex;
@property (nonatomic, strong) HomeModel *model;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL continueLoading;

@property (nonatomic, assign) BOOL isRefresh;

//@property (nonatomic, assign) NSInteger pageSize;

//@property (nonatomic, assign) NSInteger totalSize;//根据页


- (void)onMineClicked;
- (void)onDiscoverClicked;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

#pragma mark - settings and gettings
-(NSMutableArray *)dataArray
{
    if(_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - viewcontroller life cycle

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
        weakSelf.isRefresh = YES;
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
    NSURL *url = [NSURL URLWithString:@"momia://mine"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onDiscoverClicked {
    NSLog(@"onDiscoverClicked");
}


#pragma mark - web request

- (void)requestData {
    
    if(self.isRefresh) {
        self.isRefresh = NO;
        [self.dataArray removeAllObjects];
        self.startIndex = 0;
     
        [self.tableView reloadData];
    }
    
    self.continueLoading = NO;

    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * paramDic = @{@"pageindex":@(self.startIndex++)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/home") parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[HomeModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        self.continueLoading = YES;

        self.model = responseObject;
        
        [self.dataArray addObjectsFromArray:self.model.data.list];
        
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == self.dataArray.count) {
        return 44.0f;
    }
    return [HomeTopicCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row < self.dataArray.count) {
        id item = [self.model.data.list objectAtIndex:row];
        if([item isKindOfClass:[HomeTopic class]]) {
            HomeTopic * topic = item;
            NSURL *url = [NSURL URLWithString:topic.action];
            [[UIApplication sharedApplication] openURL:url];
        }
    }


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.model.data.list.count == 0) {
        return self.dataArray.count;
    }
    
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.dataArray.count) {
        static NSString * loadIdentifier = @"CellHomeLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(self.continueLoading) {
            [self requestData];
        }
    } else {
        HomeTopicCell *topic = [HomeTopicCell cellWithTableView:tableView];
        HomeTopic *data = self.dataArray[row];
        [topic setData:data];
        cell = topic;
    }
    return cell;

}

@end
