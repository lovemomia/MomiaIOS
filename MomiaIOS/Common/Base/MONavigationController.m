//
//  MONavigationController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MONavigationController.h"
#import "Constants.h"
#import "UIImage+Color.h"

@interface MONavigationController()

@property(nonatomic, assign) UIViewController *root;

@end

@implementation MONavigationController
@synthesize backView;

//-(id)init {
//    if (self = [super init]) {
//        [self setDarkTitleStyle];
//    }
//    return self;
//}

-(id)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setDarkTitleStyle];
        self.root = rootViewController;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//    item.image = [UIImage imageNamed:@"cm_back"];
//    viewController.navigationItem.backBarButtonItem = item;
    
    UIBarButtonItem * backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle: @"back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    [backBarButtonItem setImage: [UIImage imageNamed: @"cm_back"]];
//    [viewController.navigationItem setBackBarButtonItem:backBarButtonItem];
    [viewController.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

- (void)onBack {
    [self popViewControllerAnimated:YES];
}

- (void)hideNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

- (void)setDarkTitleStyle {
    // text color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    // background color
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:MO_APP_NaviColor size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    self.navigationBar.translucent = NO;
}

- (void)setLightTitleStyle {
    // text color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MO_APP_NaviColor,NSForegroundColorAttributeName,nil]];
    [self.navigationBar setTintColor:MO_APP_NaviColor];
    
    // background color
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = nil;
    self.navigationBar.translucent = NO;
}

@end
