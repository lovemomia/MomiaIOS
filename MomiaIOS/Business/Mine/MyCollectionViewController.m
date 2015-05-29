//
//  MyCollectionViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "FavouriteModel.h"
#import "MyCollectionCell.h"
#define pageSize 10

@interface MyCollectionViewController ()

@property (nonatomic, strong) FavouriteModel * favouriteModel;
@property (nonatomic, assign) NSInteger currentPage;//表示当前页，缺省为0
@property (nonatomic, assign) BOOL continueLoading;//控制request请求在执行的期间只执行一次，缺省为NO
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyCollectionViewController

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
    
    self.continueLoading = NO;
    
    if (self.favouriteModel == nil) {
        [self.view showLoadingBee];
    }
   
     NSDictionary * paramDic = @{@"start":@(self.currentPage++ * pageSize),@"count":@(pageSize)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/favorite/user") parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[FavouriteModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.favouriteModel == nil) {
            [self.view removeLoadingBee];
        }
        
        self.continueLoading = YES;
        
        self.favouriteModel = responseObject;
        
        [self.dataArray addObjectsFromArray:self.favouriteModel.data.favoriteList];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    self.navigationItem.title = @"我的收藏";
    //当单元格数目少于屏幕时会出现多余分割线，直接设置tableFooterView用以删除
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark - tableview delegate & datasource


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row < self.dataArray.count) {
        FavouriteItem * item = [self.dataArray objectAtIndex:row];
        switch (item.type) {
            case 0:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://articledetail?id=%ld", item.refId]];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 1:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://goodsdetail?id=%ld", item.refId]];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 2:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://articletopic?id=%ld", item.refId]];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 3:
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://goodstopic?id=%ld", item.refId]];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
                
            default:
                break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataArray.count&&self.dataArray.count >= self.currentPage * pageSize)
        return self.dataArray.count + 1;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.dataArray.count) {
        static NSString * loadIdentifier = @"CellMyCollectionLoading";
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
        FavouriteItem * item = [self.dataArray objectAtIndex:indexPath.row];
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
