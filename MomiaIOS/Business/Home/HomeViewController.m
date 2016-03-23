//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "IndexModel.h"
#import "HomeEventCell.h"
#import "HomeCarouselCell.h"
#import "HomeCell.h"
#import "HomeSubjectCoverCell.h"
#import "HomeSubjectCoursesCell.h"
#import "HomeTopicCell.h"
#import "LoadingCell.h"
#import "LoadingErrorCell.h"
#import "HomeOperateCell.h"
#import "MJRefreshHelper.h"
#import "NSString+MOURLEncode.h"


static NSString *homeGridIdentifier = @"CellGrid";
static NSString *homeEventIdentifier = @"CellEvent";
static NSString *homeIdentifier = @"CellHome";
static NSString *homeCarouselIdentifier = @"CellHomeCarousel";
static NSString *homeLoadingIdentifier = @"CellHomeLoading";
static NSString *homeLoadingErrorIdentifier = @"CellHomeLoadingError";
static NSString *homeSubjectCoverCellIdentifier = @"HomeSubjectCoverCell";
static NSString *homeSubjectCoursesCellIdentifier = @"HomeSubjectCoursesCell";
static NSString *homeTopicCellIdentifier = @"HomeTopicCell";

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) NSArray * banners;//当pageIndex为0时才有数据
//@property (nonatomic, strong) NSArray * icons;//当pageIndex为0时才有数据
//@property (nonatomic, strong) NSArray * events;//当pageIndex为0时才有数据
@property (strong, nonatomic) IndexModel * model;
@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isError;//加载更多的时候出错

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *childAvatarIv;
@property (nonatomic, strong) UILabel *childNameLabel;

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
//    self.navigationItem.title = @"松果亲子";

    
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    UIView * cityView = array[0];
    self.cityLabel = (UILabel *)[cityView viewWithTag:2001];
    NSString *city = [CityManager shareManager].choosedCity.name;
    [self.cityLabel setText:city];
    
    cityView.size = [cityView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    UIView *childView = array[1];
    self.childAvatarIv = [childView viewWithTag:1001];
    [self.childAvatarIv sd_setImageWithURL:nil];
    self.childNameLabel = [childView viewWithTag:1002];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleClick:)];
    [cityView addGestureRecognizer:tapRecognizer];
    
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:cityView];
    UIBarButtonItem *childItem = [[UIBarButtonItem alloc] initWithCustomView:childView];
    
    if (isCurrentDeviceSystemVersionLater(7.0)) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, childItem];
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, cityItem];
        
    } else {
        self.navigationItem.leftBarButtonItem = childItem;
        self.navigationItem.rightBarButtonItem = cityItem;
    }

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleCalendar"] style:UIBarButtonItemStylePlain target:self action:@selector(onProductCalendarClick)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClick)];
    
    [HomeEventCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeEventIdentifier];
    [HomeCarouselCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeCarouselIdentifier];
    [HomeCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeIdentifier];
    [LoadingCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingIdentifier];
    [LoadingErrorCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingErrorIdentifier];
    [HomeSubjectCoverCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeSubjectCoverCellIdentifier];
    [HomeSubjectCoursesCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeSubjectCoursesCellIdentifier];
    [HomeTopicCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeTopicCellIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.width = SCREEN_WIDTH;
    
    [self requestData:YES];
}

- (void)onCityChanged:(City *)newCity {
    [self.cityLabel setText:newCity.name];
    self.model = nil;
    [self.tableView reloadData];
    [self requestData:YES];
}

-(void)onProductCalendarClick
{
    NSURL * url = [NSURL URLWithString:@"productcalendar"];
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
    self.curOperation = [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v3/index") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[IndexModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        
        if (refresh) {
            [self.array removeAllObjects];
        }
        
        if(self.nextIndex == 0) {
            self.banners = self.model.data.banners;
//            self.icons = self.model.data.icons;
//            self.events = self.model.data.events;
        }
        
        if (self.model.data.courses.list.count > 0) {
            [self.array addObjectsFromArray:self.model.data.courses.list];
        }
        
        if (self.model.data.courses.nextIndex && [self.model.data.courses.nextIndex intValue] > 0) {
            self.nextIndex = [self.model.data.courses.nextIndex integerValue];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    header.backgroundColor = MO_APP_VCBackgroundColor;
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) {
        int number = 0;
        if (self.banners.count > 0) {
            number++;
        }
        if (self.model.data.events.count > 0) {
            number++;
        }
        number += self.model.data.subjects.count * 2;
        if (self.model.data.topics.count > 0) {
            number++;
        }
        if (self.nextIndex > 0) {
            number++;
        }
        return self.array.count + number;//第一个+1是可能有轮播，最后一个+1是分页加载更多
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    BOOL hasBannerSec = self.banners.count > 0;
    BOOL hasEventSec = self.model.data.events.count > 0;
    
    int number = (int)section;
    if (hasBannerSec) {
        if (number == 0) {
            return [HomeCarouselCell heightWithTableView:tableView];
        }
        number--;
    }
    
    if (hasEventSec) {
        if (number == 0) {
            return [HomeEventCell heightWithTableView:tableView withIdentifier:homeEventIdentifier forIndexPath:indexPath data:self.model];
        }
        number--;
    }
    
    if (number < self.model.data.subjects.count * 2) {
        IndexSubject *subject = self.model.data.subjects[number / 2];
        if (number % 2 == 0) {
            return SCREEN_WIDTH * 180 / 320;
            
        } else {
            return [HomeSubjectCoursesCell heightWithTableView:tableView withIdentifier:homeSubjectCoursesCellIdentifier forIndexPath:indexPath data:subject];
        }
    }
    
    number -= self.model.data.subjects.count * 2;
    
    if (self.model.data.topics.count > 0) {
        if (number == 0) {
            return [HomeTopicCell heightWithTableView:tableView withIdentifier:homeTopicCellIdentifier forIndexPath:indexPath data:self.model.data.topics[0]];
        }
        number--;
    }
    
    if (number < self.array.count) {
        return [HomeCell heightWithTableView:tableView withIdentifier:homeIdentifier forIndexPath:indexPath data:self.array[number]];
    }
    
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    BOOL hasBannerSec = self.banners.count > 0;
    BOOL hasEventSec = self.model.data.events.count > 0;
    
    int number = (int)section;
    if (hasBannerSec) {
        if (number == 0) {
            HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeCarouselIdentifier];
            carousel.data = self.banners;
            carousel.scrollClick = ^void(NSInteger index) {
                NSLog(@"index:%ld",(long)index);
                if(index < self.model.data.banners.count) {
                    IndexBanner * banner = self.model.data.banners[index];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.action]];
                    
                    NSDictionary *attributes = @{@"index":[NSString stringWithFormat:@"%d", index]};
                    [MobClick event:@"Home_Banner" attributes:attributes];
                }
            };
            return carousel;
        }
        number--;
    }
    
    if (hasEventSec) {
        if (number == 0) {
            HomeEventCell *operateCell = [HomeEventCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeEventIdentifier];
            operateCell.data = self.model;
            return operateCell;
        }
        number--;
    }
    
    if (number < self.model.data.subjects.count * 2) {
        IndexSubject *subject = self.model.data.subjects[number / 2];
        if (number % 2 == 0) {
            HomeSubjectCoverCell *subjectCover = [HomeSubjectCoverCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeSubjectCoverCellIdentifier];
            subjectCover.data = subject.cover;
            return subjectCover;
            
        } else {
            HomeSubjectCoursesCell *subjectCourses = [HomeSubjectCoursesCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeSubjectCoursesCellIdentifier];
            subjectCourses.data = subject;
            return subjectCourses;
        }
    }
    
    number -= self.model.data.subjects.count * 2;
    
    if (self.model.data.topics.count > 0) {
        if (number == 0) {
            HomeTopicCell *topicCell = [HomeTopicCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeTopicCellIdentifier];
            topicCell.data = self.model.data.topics[0];
            return topicCell;
        }
        number--;
    }
    
    if (number < self.array.count) {
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeIdentifier];
        home.data = self.array[number];
        return home;
    }
    
    if (self.isError) {
        LoadingErrorCell * error = [LoadingErrorCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:homeLoadingErrorIdentifier];
        error.backgroundColor = MO_APP_VCBackgroundColor;

        return error;
        
    } else {
        LoadingCell * loading = [LoadingCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:homeLoadingIdentifier];
        [loading startAnimating];
        if(!self.isLoading) {
            self.isLoading = YES;
            [self requestData:NO];
        }
        loading.backgroundColor = MO_APP_VCBackgroundColor;

        return loading;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    BOOL hasBannerSec = self.banners.count > 0;
    BOOL hasEventSec = self.model.data.events.count > 0;
    
    int number = (int)section;
    if (hasBannerSec) {
        if (number == 0) {
            // handler by it self
            return;
        }
        number--;
    }
    
    if (hasEventSec) {
        if (number == 0) {
            // handler by it self
            return;
        }
        number--;
    }
    
    if (number < self.model.data.subjects.count * 2) {
        IndexSubject *subject = self.model.data.subjects[number / 2];
        if (number % 2 == 0) {
            [self openURL:[NSString stringWithFormat:@"subjectdetail?id=%@", subject.ids]];
            return;
            
        } else {
            // handler by it self
            return;
        }
    }
    
    number -= self.model.data.subjects.count * 2;
    
    if (self.model.data.topics.count > 0) {
        if (number == 0) {
            NSString *url = [NSString stringWithFormat:@"http://%@/discuss/topic?id=%@", MO_DEBUG ? @"m.momia.cn" : @"m.sogokids.com", ((IndexSubject *)self.model.data.subjects[0]).ids];
            [self openURL:[NSString stringWithFormat:@"web?url=%@", [url URLEncodedString]]];
            return;
        }
        number--;
    }
    
    if (number < self.array.count) {
        Course *course = self.array[number];
        [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
        
        NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", number]};
        [MobClick event:@"Home_List" attributes:attributes];
        return;
        
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
