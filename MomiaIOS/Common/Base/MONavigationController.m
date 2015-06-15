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

@implementation MONavigationController
@synthesize backView;

-(id)init {
    if (self = [super init]) {
        [self setTitleStyle];
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setTitleStyle];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    viewController.navigationItem.backBarButtonItem = item;
}

- (void)showNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:MO_APP_NaviColor size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    self.navigationBar.translucent = NO;
}

- (void)hideNavigationBar {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

- (void)setTitleStyle {
    // text color
    [self setTitleTextStyle];
    
    // background color
    [self showNavigationBar];
    
    CGRect frame = self.navigationBar.frame;
    backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
    backView.backgroundColor = MO_APP_VCBackgroundColor;
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:backView.frame];
    bgImage.image = [UIImage imageWithColor:MO_APP_NaviColor size:CGSizeMake(SCREEN_WIDTH, 64)];
    [backView addSubview:bgImage];
    [[[UIApplication sharedApplication].delegate window] insertSubview:backView atIndex:0];
}

- (void)setTitleTextStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

@end
