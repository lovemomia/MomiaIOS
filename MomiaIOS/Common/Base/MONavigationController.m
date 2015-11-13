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
#import "AppDelegate.h"

@interface MONavigationController()

@property(nonatomic, assign) UIViewController *root;

@end

@implementation MONavigationController

//-(id)init {
//    if (self = [super init]) {
//        [self setDarkTitleStyle];
//    }
//    return self;
//}

-(id)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.root = rootViewController;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    [viewController.navigationItem setBackBarButtonItem:backBarButtonItem];

    
    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"TitleBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"TitleBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    [[[self viewControllers] objectAtIndex:0] setHidesBottomBarWhenPushed:NO];
    return [super popToRootViewControllerAnimated:animated];
}


- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count <= 2) {
        [[[self viewControllers] objectAtIndex:0] setHidesBottomBarWhenPushed:NO];
    }
    return [super popToViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count <= 2) {
        [[[self viewControllers] objectAtIndex:0] setHidesBottomBarWhenPushed:NO];
    }
    return [super popViewControllerAnimated:animated];
}

- (void)onBack {
    [self popViewControllerAnimated:YES];
}

- (void)hideNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setTitleShadow:nil aboveSubview:self.navigationBar];
}

- (void)setDarkTitleStyle {
    // text color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    // background color
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:MO_APP_ThemeColor size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    self.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // shadow
//    [((AppDelegate *)[UIApplication sharedApplication].delegate) setTitleShadow:[UIImage imageNamed:@"BgTitleShadow"] aboveSubview:self.navigationBar];
}

- (void)setLightTitleStyle {
    // text color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationBar setTintColor:MO_APP_ThemeColor];
    
    // background color
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    self.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // shadow
//    [((AppDelegate *)[UIApplication sharedApplication].delegate) setTitleShadow:[UIImage imageNamed:@"BgTitleShadow"] aboveSubview:self.navigationBar];
}

@end
