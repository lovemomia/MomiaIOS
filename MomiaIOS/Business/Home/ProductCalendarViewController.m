//
//  ProductCalendarViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarViewController.h"
#import "ProductCalendarMonthViewController.h"
#import "ProductCalendarWeekendViewController.h"
#import "DateManager.h"
#import "StringUtils.h"
#import "LJViewPager.h"
#import "LJTabBar.h"

@interface ProductCalendarViewController ()<LJViewPagerDataSource, LJViewPagerDelegate>

@property (strong, nonatomic) LJViewPager *viewPager;
@property (strong, nonatomic) LJTabBar *tabBar;

@property (assign, nonatomic) int month;
@property (assign, nonatomic) int nextMonth;

@end

@implementation ProductCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动日历";
    
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
    self.tabBar.titles = @[@"周末", [[StringUtils stringForMonth:month] stringByAppendingString:@"月"], [[StringUtils stringForMonth:nextMonth] stringByAppendingString:@"月"]];
    self.viewPager.tabBar = self.tabBar;
    
    self.tabBar.itemsPerPage = 3;
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
    return 3;
}

- (UIViewController *)viewPager:(LJViewPager *)viewPager controllerAtPage:(NSInteger)page {
    if (page == 0) {
        return [[ProductCalendarWeekendViewController alloc] initWithParams:nil];
    } else if (page == 1) {
        NSDictionary * dic = @{@"month":@(self.month)};
        return [[ProductCalendarMonthViewController alloc] initWithParams:dic];
    } else {
        NSDictionary * dic = @{@"month":@(self.nextMonth)};
        return [[ProductCalendarMonthViewController alloc] initWithParams:dic];
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
