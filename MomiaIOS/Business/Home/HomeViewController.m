//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "IndexModel.h"
#import "HomeCarouselCell.h"
#import "HomeCell.h"
#import "LoadingCell.h"
#import "LoadingErrorCell.h"
#import "HomeGridCell.h"
#import "HomeOperateCell.h"

static NSString *homeGridIdentifier = @"CellGrid";
static NSString *homeOperateIdentifier = @"CellOperate";
static NSString *homeIdentifier = @"CellHome";
static NSString *homeCarouselIdentifier = @"CellHomeCarousel";
static NSString *homeLoadingIdentifier = @"CellHomeLoading";
static NSString *homeLoadingErrorIdentifier = @"CellHomeLoadingError";

@interface HomeViewController ()

@property (nonatomic,strong) NSMutableArray * array;
@property (nonatomic,strong) NSArray * banners;//当pageIndex为0时才有数据
@property (nonatomic,strong) NSArray * icons;//当pageIndex为0时才有数据
@property (nonatomic,strong) NSArray * events;//当pageIndex为0时才有数据
@property (strong,nonatomic) IndexModel * model;
@property (nonatomic,assign) NSInteger nextIndex;

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
    self.navigationItem.title = @"松果亲子";

    
    
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

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleCalendar"] style:UIBarButtonItemStylePlain target:self action:@selector(onProductCalendarClick)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClick)];
    
    
    [HomeCarouselCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeCarouselIdentifier];
    [HomeCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeIdentifier];
    [LoadingCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingIdentifier];
    [LoadingErrorCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingErrorIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.header = header;
    self.tableView.width = SCREEN_WIDTH;
    
    [self requestData:YES];
}

- (void)onCityChanged:(City *)newCity {
    [self.titleLabel setText:newCity.name];
    self.model = nil;
    [self.tableView reloadData];
    [self requestData:YES];
}

-(void)onProductCalendarClick
{
    NSURL * url = [NSURL URLWithString:@"duola://productcalendar"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - webData Request

- (void)requestData {
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    [self.view removeError];
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = 0;
        self.isLoading = NO;
    }
    
    NSDictionary * dic = @{@"start":@(self.nextIndex)};
    self.curOperation = [[HttpService defaultService] GET:URL_APPEND_PATH(@"/index") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[IndexModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        
        if (refresh) {
            [self.array removeAllObjects];
        }
        
        if(self.nextIndex == 0) {
            self.banners = self.model.data.banners;
            self.icons = self.model.data.icons;
            self.events = self.model.data.events;
        }
        
        if (self.model.data.subjects.list.count > 0) {
            [self.array addObjectsFromArray:self.model.data.subjects.list];
        }
        
        if (self.model.data.subjects.nextIndex && [self.model.data.subjects.nextIndex intValue] > 0) {
            self.nextIndex = [self.model.data.subjects.nextIndex integerValue];
            
        } else {
            self.nextIndex = 0;
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        self.isError = NO;
        self.isLoading = NO;
        
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
                    [self requestData:YES];
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
    BOOL hasBannerSec = self.banners.count > 0 || self.icons.count > 0;
    BOOL hasEventSec = self.events.count > 0;
    
    int number = 0;
    if (hasBannerSec) {
        number++;
    }
    if (hasEventSec) {
        number++;
    }
    
    if (section == number) {
        return 30;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL hasBannerSec = self.banners.count > 0 || self.icons.count > 0;
    BOOL hasEventSec = self.events.count > 0;
    
    int number = 0;
    if (hasBannerSec) {
        number++;
    }
    if (hasEventSec) {
        number++;
    }
    
    UIView *view = [[UIView alloc]init];
    if (section == number) {
        view.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 10, 180, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [view addSubview:line];
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, 0, 70, 20)];
        text.textAlignment = NSTextAlignmentCenter;
        text.textColor = UIColorFromRGB(0x999999);
        text.backgroundColor = MO_APP_VCBackgroundColor;
        text.font = [UIFont systemFontOfSize:14];
        text.text = @"课程试听";
        [view addSubview:text];
    }
    return view;
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
        int number = 0;
        if (self.banners.count > 0 || self.icons.count > 0) {
            number++;
        }
        if (self.events.count > 0) {
            number++;
        }
        if (self.nextIndex > 0) {
            number++;
        }
        return self.array.count + number;//第一个+1是可能有轮播，最后一个+1是分页加载更多
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        if(self.banners.count > 0 && self.icons.count > 0) {
            return 2;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    BOOL hasBannerSec = self.banners.count > 0 || self.icons.count > 0;
    BOOL hasEventSec = self.events.count > 0;
    
    int number = 0;
    if (hasBannerSec) {
        number++;
    }
    if (hasEventSec) {
        number++;
    }
    
    if (hasBannerSec && section == 0) {
        if (hasBannerSec && indexPath.row == 0) {
            return [HomeCarouselCell heightWithTableView:tableView];
        } else {
            return [HomeGridCell heightWithTableView:tableView forModel:self.icons];
        }
        
    } else if ((hasBannerSec && hasEventSec && section == 1) || (!hasBannerSec && hasEventSec && section == 0)) {
        return [HomeOperateCell heightWithTableView:tableView forModel:self.events];
        
    } else if(section < self.array.count + number) {
        return [HomeCell heightWithTableView:tableView withIdentifier:homeIdentifier forIndexPath:indexPath data:self.array[section - number]];
        
    } else return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell * cell;

    BOOL hasBannerSec = self.banners.count > 0 || self.icons.count > 0;
    BOOL hasEventSec = self.events.count > 0;
    
    int number = 0;
    if (hasBannerSec) {
        number++;
    }
    if (hasEventSec) {
        number++;
    }
    
    if (hasBannerSec && section == 0) {
        if (self.banners.count > 0 && indexPath.row == 0) {
            HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeCarouselIdentifier];
            carousel.data = self.banners;
            carousel.scrollClick = ^void(NSInteger index) {
                NSLog(@"index:%ld",(long)index);
                if(index < self.model.data.banners.count) {
                    IndexBanner * banner = self.model.data.banners[index];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.action]];
                }
            };
            cell = carousel;
        } else {
            HomeGridCell *gridCell = [[HomeGridCell alloc]initWithTableView:tableView forModel:self.icons reuseIdentifier:homeGridIdentifier];
            cell = gridCell;
        }
        
    } else if ((hasBannerSec && hasEventSec && section == 1) || (!hasBannerSec && hasEventSec && section == 0)) {
        HomeOperateCell *operateCell = [[HomeOperateCell alloc]initWithTableView:tableView forModel:self.events reuseIdentifier:homeOperateIdentifier];
        cell = operateCell;
        
    } else if(section < self.array.count + number) {
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeIdentifier];
        home.data = self.array[section - number];
        
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
                [self requestData:NO];
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
    BOOL hasBannerSec = self.banners.count > 0 || self.icons.count > 0;
    BOOL hasEventSec = self.events.count > 0;
    
    int number = 0;
    if (hasBannerSec) {
        number++;
    }
    if (hasEventSec) {
        number++;
    }
    if (section < number) {
        
    } else if(section < self.array.count + number) {
        Subject *subject = self.array[indexPath.section - number];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://subjectdetail?id=%@", subject.ids]];
        [[UIApplication sharedApplication] openURL:url];
        
    } else {
        if(self.isError) {
            self.isError = NO;
            [self.tableView reloadData];
            if(!self.isLoading) {
                self.isLoading = YES;
                [self requestData:NO];
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
