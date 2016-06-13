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

#import "BookCourseListItemCell.h"
#import "BookedCourseListModel.h"

static NSString * identifierCourseListItemCell = @"BookCourseListItemCell";

@interface IfFinishedCourseListViewController()<BookCourseListItemCellDelegate>

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, assign) BOOL finish;
@property (nonatomic, strong) Course *cancelBookCourse;

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
    
    [BookCourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    
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
                                                         [self.view showEmptyView:@"还没有课程，赶紧去看看吧~"];
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
        [self.tableView reloadData];
    }
    [self requestData:YES];
}

- (void)onBookBtnClick:(Course *)course {
    if (self.finish) {
        [self openURL:[NSString stringWithFormat:@"addreview?id=%@&bookingId=%@", course.ids, course.bookingId]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookedChanged:) name:@"onBookedChanged" object:nil];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消预约吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.cancelBookCourse = course;
        [alter show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.cancelBookCourse) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *params = @{@"bid" : self.cancelBookCourse.bookingId};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/course/cancel") parameters:params JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [self.navigationController popViewControllerAnimated:YES];
                [self requestData:YES];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"onBookedChanged" object:nil];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDialogWithTitle:nil message:error.message];
            }];
        }
    }
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.list.count) {
        Course *course = self.list[indexPath.row];
        [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
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
        BookCourseListItemCell * itemCell = [BookCourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
        Course *course = self.list[indexPath.row];
        itemCell.data = course;
        itemCell.delegate = self;
        if (self.finish && course.commented && ![course.commented boolValue]) {
            itemCell.bookBtn.hidden = NO;
            [itemCell.bookBtn setTitle:@"评价" forState:UIControlStateNormal];
            [itemCell.bookBtn setBackgroundImage:[UIImage imageNamed:@"BgRedMediumButtonNormal"] forState:UIControlStateNormal];
            
        } else if (!self.finish) {
            itemCell.bookBtn.hidden = NO;
            [itemCell.bookBtn setTitle:@"取消预约" forState:UIControlStateNormal];
            [itemCell.bookBtn setBackgroundImage:[UIImage imageNamed:@"BgMediumButtonNormal"] forState:UIControlStateNormal];
            
        } else {
            itemCell.bookBtn.hidden = YES;
        }
        
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BookCourseListItemCell heightWithTableView:tableView withIdentifier:identifierCourseListItemCell forIndexPath:indexPath data:nil];
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
    self.tabBar.textFont = [UIFont systemFontOfSize:16];
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
