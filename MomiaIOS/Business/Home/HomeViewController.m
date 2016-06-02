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
#import "RCTRootView.h"
#import "RNCommon.h"
#import "RecommendCell.h"

static NSString *homeGridIdentifier = @"CellGrid";
static NSString *homeEventIdentifier = @"CellEvent";
static NSString *homeIdentifier = @"CellHome";
static NSString *homeCarouselIdentifier = @"CellHomeCarousel";
static NSString *homeLoadingIdentifier = @"CellHomeLoading";
static NSString *homeLoadingErrorIdentifier = @"CellHomeLoadingError";
static NSString *homeSubjectCoverCellIdentifier = @"HomeSubjectCoverCell";
static NSString *homeSubjectCoursesCellIdentifier = @"HomeSubjectCoursesCell";
static NSString *homeTopicCellIdentifier = @"HomeTopicCell";
static NSString *homeRecommendCellIdentifier = @"RecommendCell";

typedef NS_ENUM(NSInteger, HomeViewCellType) {
    HomeViewCellTypeBanner = 1,
    HomeViewCellTypeEvent = 2,
    HomeViewCellTypeSubjectCover = 3,
    HomeViewCellTypeSubject = 4,
    HomeViewCellTypeTopic = 5,
    HomeViewCellTypeCourse = 6,
    HomeViewCellTypeRecommand = 7,
};

@interface CellItem : NSObject

@property(nonatomic,assign) NSInteger itemType; //Section Cell 类型
@property(nonatomic,strong) id object;

-(instancetype)init:(HomeViewCellType)itemType obj:(id)obj;

@end

@implementation CellItem

-(instancetype)init:(HomeViewCellType)itemType obj:(id)obj{
    if (self = [super init]) {
        self.itemType = itemType;
        self.object = obj;
    }
    return self;
}

@end

@interface HomeViewController ()<AccountChangeListener>

@property (nonatomic, strong) NSArray                *banners;
@property (nonatomic, strong) IndexModel             *model;
@property (nonatomic, assign) NSInteger              nextIndex;
@property (nonatomic, assign) BOOL                   isLoading;
@property (nonatomic, assign) BOOL                   isError;//加载更多的时候出错
@property (nonatomic, strong) UILabel                *cityLabel;
@property (nonatomic, strong) UIImageView            *childAvatarIv;
@property (nonatomic, strong) UILabel                *childNameLabel;
@property (nonatomic, strong ) AFHTTPRequestOperation *curOperation;
@property (nonatomic, strong ) NSMutableArray         *dataArray;

@end

@implementation HomeViewController

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    UIView * cityView = array[0];
    self.cityLabel = (UILabel *)[cityView viewWithTag:2001];
    NSString *city = [CityManager shareManager].choosedCity.name;
    [self.cityLabel setText:city];
    
    cityView.size = [cityView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    UIView *childView = array[1];
    self.childAvatarIv = [childView viewWithTag:1001];
    self.childNameLabel = [childView viewWithTag:1002];
    [self setupTitleChild];
    
    [cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleCityClick:)]];
    [childView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleChildClick:)]];
    
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
    
    [HomeEventCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeEventIdentifier];
    [HomeCarouselCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeCarouselIdentifier];
    [HomeCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeIdentifier];
    [LoadingCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingIdentifier];
    [LoadingErrorCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeLoadingErrorIdentifier];
    [HomeSubjectCoverCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeSubjectCoverCellIdentifier];
    [HomeSubjectCoursesCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeSubjectCoursesCellIdentifier];
    [HomeTopicCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeTopicCellIdentifier];
    [RecommendCell registerCellFromNibWithTableView:self.tableView withIdentifier:homeRecommendCellIdentifier];
    
    // 设置下拉刷新
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData:YES];
    
    [[AccountService defaultService] addListener:self];

//    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/home/home.bundle?platform=ios"];
//    // For production use, this `NSURL` could instead point to a pre-bundled file on disk: //
////    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
//    // To generate that file, run the curl command and add the output to your main Xcode build target: //
//    // curl http://localhost:8081/home/home.ios.bundle -o ./ReactComponent/output/main.jsbundle
//    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"HomeComponent" initialProperties:nil launchOptions:nil];
//    rootView.frame = self.view.bounds;
//    [self.view addSubview:rootView];
}

- (void)setupTitleChild {
    if ([AccountService defaultService].isLogin) {
        [self.childAvatarIv sd_setImageWithURL:[NSURL URLWithString:[AccountService defaultService].account.avatar]];
        if ([[AccountService defaultService].account getBigChild]) {
            self.childNameLabel.text = [NSString stringWithFormat:@"%@ %@", [AccountService defaultService].account.nickName, [[AccountService defaultService].account ageWithDateOfBirth]];
        } else {
            self.childNameLabel.text = [AccountService defaultService].account.nickName;
        }
        
    } else {
        [self.childAvatarIv sd_setImageWithURL:nil];
        self.childNameLabel.text = @"松果亲子／点击登录";
    }
}

- (void)onAccountChange {
    [self requestData:YES]; //账户发生改变，更新首页
    [self setupTitleChild];
    [self.tableView.mj_header beginRefreshing];
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
            [self.dataArray removeAllObjects];
        }
        [self setData:self.model]; //设置数据
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
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
        [self.tableView.mj_header endRefreshing];
     
        NSLog(@"Error: %@", error);
    }];
}

-(void)setData:(IndexModel*)model{
    if (model) {
        if (model.data.banners.count > 0) {
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeBanner obj:model.data.banners]];
        }
        
        if (model.data.events.count > 0) {
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeEvent obj:model]];
        }
        for (int i = 0; i< model.data.subjects.count; i++) {
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeSubjectCover obj:model.data.subjects[i]]];
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeSubject obj:model.data.subjects[i]]];
            if (i < model.data.topics.count) {
                [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeTopic obj:model.data.topics[i]]];
            }
        }
        for (int i = 0; i < model.data.courses.list.count; i++) {
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeCourse obj:model.data.courses.list[i]]];
        }
        for (int i = 0; i < model.data.recommends.count; i++){
            [self.dataArray addObject:[[CellItem alloc]init:HomeViewCellTypeRecommand obj:model.data.recommends[i]]];
        }
    }
}

- (BOOL)isNavDarkStyle {
    return true;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,0,0,0);
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    CellItem *item = self.dataArray[section];
    switch (item.itemType) {
        case HomeViewCellTypeBanner:
            return [HomeCarouselCell heightWithTableView:tableView];
            break;
        case HomeViewCellTypeEvent:
            return [HomeEventCell heightWithTableView:tableView withIdentifier:homeEventIdentifier forIndexPath:indexPath data:self.model];
            break;
        case HomeViewCellTypeSubjectCover:
            return SCREEN_WIDTH * 180 / 320;
            break;
        case HomeViewCellTypeSubject:
            return [HomeSubjectCoursesCell heightWithTableView:tableView withIdentifier:homeSubjectCoursesCellIdentifier forIndexPath:indexPath data:item.object];
            break;
        case HomeViewCellTypeTopic:
            return [HomeTopicCell heightWithTableView:tableView withIdentifier:homeTopicCellIdentifier forIndexPath:indexPath data:item.object];
            break;
        case HomeViewCellTypeRecommand:
            return 110;
            break;
            default:
            return [HomeCell heightWithTableView:tableView withIdentifier:homeIdentifier forIndexPath:indexPath data:item.object];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    CellItem *item = self.dataArray[section];
    if (item.itemType == HomeViewCellTypeBanner) {
        HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeCarouselIdentifier];
        carousel.data = item.object;
        carousel.scrollClick = ^void(NSInteger index) {
            NSLog(@"index:%ld",(long)index);
            if(index < self.model.data.banners.count) {
                IndexBanner * banner = self.model.data.banners[index];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.action]];
                NSDictionary *attributes = @{@"index":[NSString stringWithFormat:@"%d", (int)index]};
                [MobClick event:@"Home_Banner" attributes:attributes];
            }
        };
        return carousel;
        
    } else if (item.itemType == HomeViewCellTypeEvent) {
        HomeEventCell *operateCell = [HomeEventCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeEventIdentifier];
        operateCell.data = item.object;
        return operateCell;

    } else if(item.itemType == HomeViewCellTypeSubjectCover) {
        HomeSubjectCoverCell *subjectCover = [HomeSubjectCoverCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeSubjectCoverCellIdentifier];
        subjectCover.data = [item.object cover];
        return subjectCover;

    } else if(item.itemType == HomeViewCellTypeSubject) {
        HomeSubjectCoursesCell *subjectCourses = [HomeSubjectCoursesCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeSubjectCoursesCellIdentifier];
        subjectCourses.data = item.object;
        return subjectCourses;
    } else if(item.itemType == HomeViewCellTypeTopic) {
        HomeTopicCell *topicCell = [HomeTopicCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeTopicCellIdentifier];
        topicCell.data = item.object;
        return topicCell;

    } else if(item.itemType == HomeViewCellTypeCourse) {
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeIdentifier];
        home.data = item.object;
        return home;

    } else if (item.itemType == HomeViewCellTypeRecommand) {
        RecommendCell *recommendCell = [RecommendCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:homeRecommendCellIdentifier];
        recommendCell.data = item.object;
        return recommendCell;
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
    int number = (int)section;
    CellItem *item = [self.dataArray objectAtIndex:section];
    if (item.itemType == HomeViewCellTypeSubjectCover) {
        IndexSubject *subject = item.object;
        [self openURL:[NSString stringWithFormat:@"subjectdetail?id=%@", subject.ids]];
    } else if(item.itemType == HomeViewCellTypeTopic) {
        NSString *url = [NSString stringWithFormat:@"http://%@/discuss/topic?id=%@", MO_DEBUG ? @"m.momia.cn" : @"m.sogokids.com", ((IndexSubject *)item.object).ids];
        [self openURL:[NSString stringWithFormat:@"web?url=%@", [url URLEncodedString]]];
    } else if(item.itemType == HomeViewCellTypeCourse) {
        Course *course = item.object;
        [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@&recommend=1", course.ids]];
        NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", number]};
        [MobClick event:@"Home_List" attributes:attributes];
    } else if(item.itemType == HomeViewCellTypeRecommand) {
        IndexRecommend *recommend = item.object;
//        [[UIApplication sharedApplication]openURL:[];
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
         
-(void)onTitleChildClick:(UITapGestureRecognizer *)recognizer
{
   [self openURL:@"personinfo"];

}

-(void)onTitleCityClick:(UITapGestureRecognizer *)recognizer
{
    [[CityManager shareManager]chooseCity:self];
    [[CityManager shareManager]addCityChangeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[CityManager shareManager] removeCityChangeListener:self];
    [[AccountService defaultService] removeListener:self];
}

@end
