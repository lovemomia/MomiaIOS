//
//  MySuggestViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MySuggestViewController.h"
#import "MySuggestModel.h"
#import "MyCollectionCell.h"
#define pageSize 10

@interface MySuggestViewController ()

@property (nonatomic, strong) MySuggestModel * suggestModel;
@property (nonatomic, assign) NSInteger currentPage;//表示当前页，缺省为0
@property (nonatomic, assign) BOOL continueLoading;//控制request请求在执行的期间只执行一次，缺省为NO
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) BOOL isRefresh;


@end

@implementation MySuggestViewController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


#pragma mark - requestData
//请求评论详情数据
- (void)requestData {
    
    if(self.isRefresh) {//表明是发送成功后的请求
        self.isRefresh = NO;
        [self.dataArray removeAllObjects];
        self.currentPage = 0;
        [self.tableView reloadData];
    }

    
    self.continueLoading = NO;
    
    if (self.suggestModel == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * paramDic = @{@"start":@(self.currentPage++ * pageSize),@"count":@(pageSize)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/goods/user") parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[MySuggestModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.suggestModel == nil) {
            [self.view removeLoadingBee];
        }
        
        self.continueLoading = YES;
        
        self.suggestModel = responseObject;
        
        NSLog(@"suggestModel:%@",self.suggestModel);
        
        [self.dataArray addObjectsFromArray:self.suggestModel.data.goodsList];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}


/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的推荐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我要推荐" style:UIBarButtonItemStylePlain target:self action:@selector(onSuggestClicked)];
    //当单元格数目少于屏幕时会出现多余分割线，直接设置tableFooterView用以删除
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];

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

- (void)onSuggestClicked {
    [self openURL:@"duola://sugsubmit"];
}


#pragma mark - tableview delegate & datasource


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataArray.count&&self.dataArray.count >= self.currentPage * pageSize)
        return self.dataArray.count + 1;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //注：我的推荐视图跟我的收藏一样，直接使用收藏的xib
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.dataArray.count) {
        static NSString * loadIdentifier = @"CellMySuggestLoading";
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
        MysuggestItem * item = [self.dataArray objectAtIndex:indexPath.row];
        MyCollectionCell * collection = [MyCollectionCell cellWithTableView:tableView withData:item];
        cell = collection;
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == self.dataArray.count) {
        return 44.0f;
    }
    
    return [MyCollectionCell height];
}


@end
