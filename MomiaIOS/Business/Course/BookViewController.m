//
//  BookViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookViewController.h"
#import "BookSkuListViewController.h"
#import "DateManager.h"
#import "StringUtils.h"
#import "LJViewPager.h"
#import "LJTabBar.h"

@interface BookViewController ()<LJViewPagerDataSource, LJViewPagerDelegate, OnSkuSelectDelegate>

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) BOOL onlyShow;

@property (strong, nonatomic) LJViewPager *viewPager;
@property (strong, nonatomic) LJTabBar *tabBar;

@property (assign, nonatomic) int month;
@property (assign, nonatomic) int nextMonth;

@property (nonatomic, strong) BookSkuListViewController *weekController;
@property (nonatomic, strong) BookSkuListViewController *firstMonthController;
@property (nonatomic, strong) BookSkuListViewController *secondMonthController;

@property (nonatomic, strong) CourseSku *selectSku;

@end

@implementation BookViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
        self.pid = [params objectForKey:@"pid"];
        self.onlyShow = [[params objectForKey:@"onlyshow"]boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.onlyShow) {
        self.navigationItem.title = @"预约课程";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneClick)];
    } else {
        self.navigationItem.title = @"课程表";
    }
    
    int month = [DateManager shareManager].serverTimeMonth;
    
    int nextMonth;
    if(month + 1 > 12) {
        nextMonth = 1;
    } else nextMonth = month + 1;
    
    self.month = month;
    self.nextMonth = nextMonth;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.viewPager];
    [self.view addSubview:self.tabBar];
    self.viewPager.viewPagerDateSource = self;
    self.viewPager.viewPagerDelegate = self;
    self.tabBar.titles = @[[[StringUtils stringForMonth:month] stringByAppendingString:@"月"], [[StringUtils stringForMonth:nextMonth] stringByAppendingString:@"月"]];
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

- (void)onDoneClick {
    if (self.selectSku) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *params = @{@"sid":self.selectSku.ids, @"pid":self.pid};
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/course/booking")
                               parameters:params JSONModelClass:[BaseModel class]
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [self showDialogWithTitle:nil message:@"预约成功，您已被拉入该课群组，猛戳 “我的—我的群组” 就可以随意调戏我们的老师啦~" tag:1];
                                  }
         
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [self showDialogWithTitle:nil message:error.message];
                                  }];
        
    } else {
        [self showDialogWithTitle:nil message:@"您还没有选择课程！"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)onSkuSelect:(CourseSku *)sku inController:(id)controller {
    self.selectSku = sku;
    if (![self.weekController isEqual:controller]) {
        [self.weekController clearChooseStatus];
    }
    if (![self.firstMonthController isEqual:controller]) {
        [self.firstMonthController clearChooseStatus];
    }
    if (![self.secondMonthController isEqual:controller]) {
        [self.secondMonthController clearChooseStatus];
    }
}

#pragma mark - pager view data source
- (UIViewController *)viewPagerInViewController {
    return self;
}

- (NSInteger)numbersOfPage {
    return 2;
}

- (UIViewController *)viewPager:(LJViewPager *)viewPager controllerAtPage:(NSInteger)page {
//    if (page == 0) {
//        NSDictionary * dic = @{@"id":self.ids, @"onlyshow":(self.onlyShow ? @"1" : @"0")};
//        self.weekController = [[BookSkuListViewController alloc] initWithParams:dic];
//        self.weekController.delegate = self;
//        return self.weekController;
//        
//    } else
    if (page == 0) {
        NSDictionary * dic = @{@"id":self.ids, @"month":@(self.month), @"onlyshow":(self.onlyShow ? @"1" : @"0")};
        self.firstMonthController = [[BookSkuListViewController alloc] initWithParams:dic];
        self.firstMonthController.delegate = self;
        return self.firstMonthController;
        
    } else {
        NSDictionary * dic = @{@"id":self.ids, @"month":@(self.nextMonth), @"onlyshow":(self.onlyShow ? @"1" : @"0")};
        self.secondMonthController = [[BookSkuListViewController alloc] initWithParams:dic];
        self.secondMonthController.delegate = self;
        return self.secondMonthController;
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
