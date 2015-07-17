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
#import "MOTabHost.h"
#import "DateManager.h"

@interface ProductCalendarViewController ()

@property(nonatomic,weak) MOViewController * currentViewController;
@property(nonatomic,strong) UIView * contentView;

@end

@implementation ProductCalendarViewController

-(UIView *)contentView
{
    if(!_contentView) {
        _contentView = [[UIView alloc] init];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动日历";
    
    __weak ProductCalendarViewController * weakSelf = self;
    
    int month = [DateManager shareManager].serverTimeMonth;
    
    MOTabHost * tabHost = [[MOTabHost alloc] initWithItems:[NSArray arrayWithObjects:@"周末", @"七月", @"八月", nil]];
    tabHost.onItemClickedListener = ^(NSInteger index) {
        MOViewController * toVC = [weakSelf.childViewControllers objectAtIndex:index];
        if(weakSelf.currentViewController == toVC) {
            return ;
        }
        
        [weakSelf transitionFromViewController:weakSelf.currentViewController toViewController:toVC duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
        } completion:^(BOOL finished) {
            if(finished) {
                weakSelf.currentViewController = toVC;
                [toVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.contentView);
                }];
            }
        }];
        
    };
    [tabHost setItemSelect:0];
    [self.view addSubview:tabHost];

    ProductCalendarWeekendViewController * firstController = [[ProductCalendarWeekendViewController alloc] initWithParams:nil];
    [self addChildViewController:firstController];
    
    ProductCalendarMonthViewController * secondController = [[ProductCalendarMonthViewController alloc] initWithParams:nil];
    [self addChildViewController:secondController];
    
    ProductCalendarMonthViewController * thirdController = [[ProductCalendarMonthViewController alloc] initWithParams:nil];
    [self addChildViewController:thirdController];
    
    [self.contentView addSubview:firstController.view];
    
    [firstController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.currentViewController = firstController;
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
