//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeCarouselCell.h"
#import "HomeCell.h"
#import "LoadingCell.h"
#import "LoadingErrorCell.h"

static NSString * homeIdentifier = @"CellHome";
static NSString * homeCarouselIdentifier = @"CellHomeCarousel";
static NSString * homeLoadingIdentifier = @"CellHomeLoading";
static NSString * homeLoadingErrorIdentifier = @"CellHomeLoadingError";

@interface HomeViewController ()

@property (nonatomic,strong) NSMutableArray * array;
@property (nonatomic,strong) NSArray * banners;//当pageIndex为0时才有数据
@property (strong,nonatomic) HomeModel * model;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL continueLoading;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isError;//加载更多的时候出错

@property(nonatomic,strong) UILabel * titleLabel;

@property(nonatomic,strong) AFHTTPRequestOperation * curOperation;

@end

@implementation HomeViewController

-(NSMutableArray *)array
{
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"哆啦亲子";

    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    UIView * titleView = array[0];
    self.titleLabel = (UILabel *)[titleView viewWithTag:2001];
    NSString *city = [CityManager shareManager].choosedCity.name;
    [self.titleLabel setText:city];
    
    titleView.size = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleClick:)];
    [titleView addGestureRecognizer:tapRecognizer];
    
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    if (isCurrentDeviceSystemVersionLater(7.0)) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, cityItem];
        
    } else {
        self.navigationItem.leftBarButtonItem = cityItem;
    }

    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClick)];
    
    
    [HomeCarouselCell registerCellWithTableView:self.tableView withIdentifier:homeCarouselIdentifier];
    [HomeCell registerCellWithTableView:self.tableView withIdentifier:homeIdentifier];
    [LoadingCell registerCellWithTableView:self.tableView withIdentifier:homeLoadingIdentifier];
    [LoadingErrorCell registerCellWithTableView:self.tableView withIdentifier:homeLoadingErrorIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.tableView.width = SCREEN_WIDTH;
    
    [self requestData];
}

- (void)onCityChanged:(City *)newCity {
    [self.titleLabel setText:newCity.name];
    self.model = nil;
    [self.tableView reloadData];
    [self requestData];
}

#pragma mark - webData Request

- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    [self.view removeError];
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    if(self.isLoading) {//表明是在进行加载更多的刷新
        
    } else {//表明就是刷新
        self.pageIndex = 0;
    }
    
    NSDictionary * dic = @{@"pageindex":@(self.pageIndex)};
    self.curOperation = [[HttpService defaultService] GET:URL_APPEND_PATH(@"/home") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[HomeModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        
        if(self.isLoading) {
            
        } else {
            self.banners = nil;
            [self.array removeAllObjects];
        }
        
        self.isError = NO;
        
        self.isLoading = NO;
        if(self.pageIndex == 0)
            self.banners = self.model.data.banners;
        
        if(self.model.data.products.count > 0) {
            self.continueLoading = YES;
            [self.array addObjectsFromArray:self.model.data.products];
        }
        else self.continueLoading = NO;
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        
        if(self.isLoading) {//正在加载更多的时候出错了
            
            self.isError = YES;
            self.isLoading = NO;
            [self.tableView reloadData];
            
        } else {//就是刷新
            
            if(self.model) {//表明下拉刷新出错
                //do nothing
            } else {//表明第一次进应用刷新出错
                [self.view removeError];
                [self.view showError:error.message retry:^{
                    [self.view removeError];
                    [self requestData];
                }];
            }
            
        }
        [self.tableView.header endRefreshing];
     
        NSLog(@"Error: %@", error);
    }];
}

- (BOOL)isNavDarkStyle {
    return true;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    header.backgroundColor = MO_APP_VCBackgroundColor;
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) {
        NSInteger number = 0;
        if(self.continueLoading) {
            number = 1;
        }
        return 1 + self.array.count + number;//第一个+1是可能有轮播，最后一个+1是分页加载更多
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if(self.banners.count > 0) {
            return 1;
        } else return 0;
    } else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0) return [HomeCarouselCell heightWithTableView:tableView];
    else if(section < self.array.count + 1)
        return [HomeCell heightWithTableView:tableView withIdentifier:homeIdentifier forIndexPath:indexPath data:self.array[section - 1]];
    else return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell * cell;

    if(section == 0) {
        HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeCarouselIdentifier];
        carousel.data = self.banners;
        carousel.scrollClick = ^void(NSInteger index) {

        };
        cell = carousel;
        
    } else if(section < self.array.count + 1){
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeIdentifier];
        home.data = self.array[section - 1];
        
        cell = home;
    } else {
        if(self.isError) {
            LoadingErrorCell * error = [LoadingErrorCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:homeLoadingErrorIdentifier];
            error.backgroundColor = MO_APP_VCBackgroundColor;
            cell = error;
        } else {
            LoadingCell * loading = [LoadingCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:homeLoadingIdentifier];
            [loading startAnimating];
            if(!self.isLoading) {
                self.isLoading = YES;
                self.pageIndex++;
                [self requestData];
            }
            loading.backgroundColor = MO_APP_VCBackgroundColor;
            cell = loading;
        }
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0) {
        
    } else if(section < self.array.count + 1) {
        ProductModel *product;
        product = self.array[indexPath.section - 1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://productdetail?id=%ld", product.pID]];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        if(self.isError) {
            self.isError = NO;
            [self.tableView reloadData];
            if(!self.isLoading) {
                self.isLoading = YES;
                [self requestData];
            }

        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)onSearchClick
{
   

}

-(void)onTitleClick:(UITapGestureRecognizer *)recognizer
{
    [[CityManager shareManager]chooseCity:self];
    [[CityManager shareManager]addCityChangeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[CityManager shareManager] removeCityChangeListener:self];
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
