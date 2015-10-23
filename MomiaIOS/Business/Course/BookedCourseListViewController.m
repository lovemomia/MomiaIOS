//
//  BookedCourseListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/20.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookedCourseListViewController.h"
#import "BookSkuListViewController.h"
#import "StringUtils.h"
#import "LJViewPager.h"
#import "LJTabBar.h"

#import "CourseListItemCell.h"
#import "BookedCourseListModel.h"

static NSString * identifierCourseListItemCell = @"CourseListItemCell";

@interface IfFinishedCourseListViewController()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, assign) BOOL finish;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation IfFinishedCourseListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
        self.finish = [[params objectForKey:@"finish"] boolValue];
    }
    return self;
}

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    
    self.list = [NSMutableArray new];
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.list count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = 0;
        self.isLoading = NO;
    }
    
    NSString *path = self.finish ? @"/user/course/finished" : @"/user/course/notfinished";
    
    NSDictionary * paramDic = @{@"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[BookedCourseListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     BookedCourseListModel *model = (BookedCourseListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     if ([model.data.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"还没有已选择的课程，赶紧去看看吧~"];
                                                         return;
                                                     }
                                                     
                                                     for (Course *course in model.data.list) {
                                                         [self.list addObject:course];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (void)onBookedChanged:(NSNotification*)notify {
    if (self.list) {
        [self.list removeAllObjects];
    }
    [self requestData:YES];
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.list.count) {
        Course *course = self.list[indexPath.row];
        if (self.finish) {
            [self openURL:[NSString stringWithFormat:@"duola://coursedetail?id=%@", course.ids]];
        } else {
            [self openURL:[NSString stringWithFormat:@"duola://bookcoursedetail?id=%@&bid=%@", course.ids, course.bookingId]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookedChanged:) name:@"onBookedChanged" object:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex > 0) {
        return self.list.count + 1;
    }
    return self.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.list.count) {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData:NO];
            self.isLoading = YES;
        }
        
    } else {
        CourseListItemCell * itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end


@interface BookedCourseListViewController ()<LJViewPagerDataSource, LJViewPagerDelegate>

@property (strong, nonatomic) LJViewPager *viewPager;
@property (strong, nonatomic) LJTabBar *tabBar;


@end

@implementation BookedCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"已选课程";
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.viewPager];
    [self.view addSubview:self.tabBar];
    self.viewPager.viewPagerDateSource = self;
    self.viewPager.viewPagerDelegate = self;
    self.tabBar.titles = @[@"待上课", @"已上课"];
    self.viewPager.tabBar = self.tabBar;
    
    self.tabBar.itemsPerPage = 2;
    self.tabBar.showShadow = NO;
    self.tabBar.textColor = UIColorFromRGB(0x333333);
    self.tabBar.textFont = [UIFont systemFontOfSize:15];
    self.tabBar.selectedTextColor = MO_APP_ThemeColor;
    self.tabBar.indicatorColor = MO_APP_ThemeColor;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pager view data source
- (UIViewController *)viewPagerInViewController {
    return self;
}

- (NSInteger)numbersOfPage {
    return 2;
}

- (UIViewController *)viewPager:(LJViewPager *)viewPager controllerAtPage:(NSInteger)page {
    if (page == 0) {
        NSDictionary * dic = @{@"finish":@"0"};
        return [[IfFinishedCourseListViewController alloc] initWithParams:dic];
    } else {
        NSDictionary * dic = @{@"finish":@"1"};
        return [[IfFinishedCourseListViewController alloc] initWithParams:dic];
    }
}

#pragma mark - pager view delegate
- (void)viewPager:(LJViewPager *)viewPager didScrollToPage:(NSInteger)page {
}

- (void)viewPager:(LJViewPager *)viewPager didScrollToOffset:(CGPoint)offset {
    
}

- (UIView *)tabBar {
    if (_tabBar == nil) {
        int tabHeight = 44;
        _tabBar = [[LJTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tabHeight)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _tabBar;
}

- (LJViewPager *)viewPager {
    if (_viewPager == nil) {
        _viewPager = [[LJViewPager alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.tabBar.frame),
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height - CGRectGetMaxY(self.tabBar.frame))];
        _viewPager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _viewPager;
}

@end
