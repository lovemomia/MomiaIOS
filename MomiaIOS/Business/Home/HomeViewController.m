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

static NSString * homeIdentifier = @"CellHome";
static NSString * homeCarouselIdentifier = @"CellHomeCarousel";

@interface HomeViewController ()
@property (strong,nonatomic) HomeModel * model;

@property(nonatomic,strong) NSString * titleStr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
    self.titleStr = @"上海";
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    UIView * titleView = array[0];
    __weak UILabel * label = (UILabel *)[titleView viewWithTag:2001];
    [label setText:self.titleStr];
    
    titleView.size = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleClick:)];
    [titleView addGestureRecognizer:tapRecognizer];
    
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_mine"] style:UIBarButtonItemStylePlain target:self action:@selector(onMineClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClick)];
    
    
    [HomeCarouselCell registerCellWithTableView:self.tableView withIdentifier:homeCarouselIdentifier];
    [HomeCell registerCellWithTableView:self.tableView withIdentifier:homeIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
}

#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"pageindex":@0};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/home") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[HomeModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (BOOL)isNavDarkStyle {
    return true;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) {
        if (self.model.data.banners.count > 0) {
            return 1 + self.model.data.products.count;
        } else {
            return self.model.data.products.count;
        }
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if(self.model.data.banners.count > 0) {
            return 1;
        } else return 0;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0) return [HomeCarouselCell heightWithTableView:tableView];
    
    return [HomeCell heightWithTableView:tableView withIdentifier:homeIdentifier forIndexPath:indexPath data:self.model.data.products[section - 1]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell * cell;

    if(section == 0) {
        HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeCarouselIdentifier];
        carousel.data = self.model.data.banners;
        carousel.scrollClick = ^void(NSInteger index) {
            NSLog(@"index:%ld",index);
        };
        cell = carousel;
        
    } else {
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeIdentifier];
        home.data = self.model.data.products[section - 1];
        
        cell = home;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *product;
    if (self.model.data.banners.count > 0) {
        product = self.model.data.products[indexPath.section - 1];
        
    } else {
        product = self.model.data.products[indexPath.section];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tq://productdetail?id=%ld", product.pID]];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)onMineClick
{
    NSURL * url = [NSURL URLWithString:@"tq://mine"];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)onSearchClick
{
//    NSURL * url = [NSURL URLWithString:@"tq://activitydetail"];
//    [[UIApplication sharedApplication] openURL:url];

}

-(void)onTitleClick:(UITapGestureRecognizer *)recognizer
{
    
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
