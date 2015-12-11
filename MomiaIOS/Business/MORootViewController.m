//
//  MORootViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MORootViewController.h"
#import "MONavigationController.h"
#import "HomeViewController.h"
#import "FeedListViewController.h"
#import "MineViewController.h"
#import "UIImage+Color.h"
#import <RongIMKit/RongIMKit.h>

@interface MORootViewController ()<UITabBarControllerDelegate> {
    
}
@property (nonatomic, strong) HomeViewController *home;
@property (nonatomic, strong) FeedListViewController *playmate;
@property (nonatomic, strong) MineViewController *mine;

@property (nonatomic, strong) UIImageView *dotImage;

@end

@implementation MORootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.tintColor = MO_APP_ThemeColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           UIColorFromRGB(0X666666), NSForegroundColorAttributeName,
                                                           nil] forState:UIControlStateNormal];
        UIColor *titleHighlightedColor = MO_APP_ThemeColor;
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           titleHighlightedColor, NSForegroundColorAttributeName,
                                                           nil] forState:UIControlStateSelected];

        
        _home = [[HomeViewController alloc]initWithParams:nil];
        _home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"精品课" image:[UIImage imageNamed:@"TabHomeNormal"] selectedImage:[UIImage imageNamed:@"TabHomeSelect"]];
        _home.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        _playmate = [[FeedListViewController alloc]initWithParams:nil];
        _playmate.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"成长说" image:[UIImage imageNamed:@"TabPlaymateNormal"] selectedImage:[UIImage imageNamed:@"TabPlaymateSelect"]];
        _playmate.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        _mine = [[MineViewController alloc]initWithParams:nil];
        _mine.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"TabMineNormal"] selectedImage:[UIImage imageNamed:@"TabMineSelect"]];
        _mine.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        MONavigationController *navHome = [[MONavigationController alloc] initWithRootViewController:_home];
        MONavigationController *navPlaymate = [[MONavigationController alloc] initWithRootViewController:_playmate];
        MONavigationController *navMine = [[MONavigationController alloc] initWithRootViewController:_mine];
        
        self.viewControllers = [NSArray arrayWithObjects:
                                navHome,
                                navPlaymate,
                                navMine,
                                nil];
        
        self.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMineDotChanged:) name:@"onMineDotChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self makeMineDotHidden];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMineDotChanged" object:nil];
}

- (void)onMineDotChanged:(NSNotification*)notify {
    [self makeMineDotHidden];
}

- (void)makeMineDotHidden {
    if ([[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]] > 0) {
        [self.dotImage removeFromSuperview];
        self.dotImage = [[UIImageView alloc] init];
        self.dotImage.backgroundColor = MO_APP_TextColor_red;
        CGRect tabFrame = self.tabBar.frame;
        CGFloat x = ceilf(0.86 * tabFrame.size.width);
        CGFloat y = ceilf(0.2 * tabFrame.size.height);
        self.dotImage.frame = CGRectMake(x, y, 6, 6);
        self.dotImage.layer.cornerRadius = 3;
        [self.tabBar addSubview:self.dotImage];
        [self.tabBar setNeedsDisplay];
        
    } else {
        [self.dotImage removeFromSuperview];
    }
}

- (void)makeTabBarHidden:(BOOL)hide {
    if ([self.view.subviews count] < 2)
        return;
    
    UIView *contentView;
    
    if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if (hide) {
        contentView.frame = self.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    
    self.tabBar.hidden = hide;
}

@end
