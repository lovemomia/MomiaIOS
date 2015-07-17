//
//  MineOrderListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MOTabHost.h"
#import "OrderListViewController.h"

@interface MyOrderListViewController ()
@property (nonatomic, strong) OrderListViewController *payedOrderListViewController;
@property (nonatomic, strong) OrderListViewController *payingOrderListViewController;
@property (nonatomic, strong) OrderListViewController *allOrderListViewController;

@property (nonatomic, strong) OrderListViewController *currentViewController;
@end

@implementation MyOrderListViewController
@synthesize payedOrderListViewController;
@synthesize payingOrderListViewController;
@synthesize allOrderListViewController;
@synthesize currentViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的订单";
    
    MOTabHost *tabHost = [[MOTabHost alloc] initWithItems:[NSArray arrayWithObjects:@"未消费", @"待付款", @"全部", nil]];
    [tabHost setItemSelect:0];
    tabHost.onItemClickedListener = ^(NSInteger index){
        if ((currentViewController == self.payedOrderListViewController && index == 0) || (currentViewController == payingOrderListViewController && index == 1) ||(currentViewController == allOrderListViewController && index == 2)) {
            return;
        }
        
        OrderListViewController *oldViewController = currentViewController;
        if (index == 0) {
            [self transitionFromViewController:currentViewController toViewController:payedOrderListViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController = payedOrderListViewController;
                } else {
                    currentViewController = oldViewController;
                }
            }];
            
        } else if (index == 1) {
            [self transitionFromViewController:currentViewController toViewController:payingOrderListViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController = payingOrderListViewController;
                } else {
                    currentViewController = oldViewController;
                }
            }];
            
        } else if (index == 2) {
            [self transitionFromViewController:currentViewController toViewController:allOrderListViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController = allOrderListViewController;
                } else {
                    currentViewController = oldViewController;
                }
            }];
        }
        
        
    };
    [self.view addSubview:tabHost];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [self.view addSubview:contentView];
    
    self.payedOrderListViewController = [[OrderListViewController alloc]initWithParams:@{@"status":@"3"}];
    [self addChildViewController:self.payedOrderListViewController];
    
    self.payingOrderListViewController = [[OrderListViewController alloc]initWithParams:@{@"status":@"2"}];
    [self addChildViewController:self.payingOrderListViewController];
    
    self.allOrderListViewController = [[OrderListViewController alloc]initWithParams:@{@"status":@"1"}];
    [self addChildViewController:self.allOrderListViewController];
    
    [contentView addSubview:self.payedOrderListViewController.view];
    self.currentViewController = self.payedOrderListViewController;
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
