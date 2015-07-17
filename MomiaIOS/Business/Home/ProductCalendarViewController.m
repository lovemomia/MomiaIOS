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

@interface ProductCalendarViewController ()

@property(nonatomic,strong) MOViewController * currentViewController;
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
    
    MOTabHost * tabHost = [[MOTabHost alloc] initWithItems:[NSArray arrayWithObjects:@"周末", @"七月", @"八月", nil]];
    tabHost.onItemClickedListener = ^(NSInteger index) {
        NSLog(@"index:%ld",(long)index);
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
    
    [firstController didMoveToParentViewController:self];

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
