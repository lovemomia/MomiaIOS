//
//  MineOrderListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderListViewController.h"
#import "LJViewPager.h"
#import "LJTabBar.h"

@interface MyOrderListViewController () <LJViewPagerDataSource, LJViewPagerDelegate>

@property (strong, nonatomic) LJViewPager *viewPager;
@property (strong, nonatomic) LJTabBar *tabBar;

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的订单";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.viewPager];
    [self.view addSubview:self.tabBar];
    self.viewPager.viewPagerDateSource = self;
    self.viewPager.viewPagerDelegate = self;
    self.tabBar.titles = @[@"未消费", @"待付款", @"全部"];
    self.viewPager.tabBar = self.tabBar;
    
    self.tabBar.itemsPerPage = 3;
    self.tabBar.showShadow = NO;
    self.tabBar.textColor = UIColorFromRGB(0x333333);
    self.tabBar.textFont = [UIFont systemFontOfSize:15];
    self.tabBar.selectedTextColor = MO_APP_ThemeColor;
    self.tabBar.indicatorColor = MO_APP_ThemeColor;
}

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
        return [[OrderListViewController alloc]initWithParams:@{@"status":@"3"}];
    } else if (page == 1) {
        return [[OrderListViewController alloc]initWithParams:@{@"status":@"2"}];
    } else {
        return [[OrderListViewController alloc]initWithParams:@{@"status":@"1"}];
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
