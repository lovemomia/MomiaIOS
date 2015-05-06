//
//  MOViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface MOViewController ()

@end

@implementation MOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(MO_OS_VERSION >= 7.0)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:232/255.0f green:83/255.0f  blue:133/255.0f alpha:1.0f]];
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
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

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:nil bundle:nil]) {
        // todo
    }
    return self;
}



@end
