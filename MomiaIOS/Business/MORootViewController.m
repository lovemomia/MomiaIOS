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
#import "HomeViewControllerV2.h"
#import "GroupListViewController.h"
#import "MineViewController.h"
#import "UIImage+Color.h"
#import "HomeViewController3.h"
#import <RongIMKit/RongIMKit.h>

@interface MORootViewController ()<UITabBarControllerDelegate> {
    
}
@property (nonatomic, strong) HomeViewController3 *home;
@property (nonatomic, strong) GroupListViewController *group;
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

        
        _home = [[HomeViewController3 alloc]initWithParams:nil];
        _home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"精品课" image:[UIImage imageNamed:@"TabHomeNormal"] selectedImage:[UIImage imageNamed:@"TabHomeSelect"]];
        _home.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        _group = [[GroupListViewController alloc]initWithParams:nil];
        _group.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"群组" image:[UIImage imageNamed:@"TabPlaymateNormal"] selectedImage:[UIImage imageNamed:@"TabPlaymateSelect"]];
        _group.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        _mine = [[MineViewController alloc]initWithParams:nil];
        _mine.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"TabMineNormal"] selectedImage:[UIImage imageNamed:@"TabMineSelect"]];
        _mine.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        MONavigationController *navHome = [[MONavigationController alloc] initWithRootViewController:_home];
        MONavigationController *navGroup = [[MONavigationController alloc] initWithRootViewController:_group];
        MONavigationController *navMine = [[MONavigationController alloc] initWithRootViewController:_mine];
        
        self.viewControllers = [NSArray arrayWithObjects:
                                navHome,
                                navGroup,
                                navMine,
                                nil];
        
        self.delegate = self;
    }
    return self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"群组"]) {
        if ([[AccountService defaultService]isLogin]) {
            return YES;
        } else {
            [[AccountService defaultService] login:self success:^{
                self.tabBarController.selectedIndex = 1;
            }];
            return NO;
        }
    }
    else
        return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMineDotChanged:) name:@"onMineDotChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self makeGroupDotHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMineDotChanged" object:nil];
}

- (void)onMineDotChanged:(NSNotification*)notify {
    [self makeGroupDotHidden];
}

- (void)makeGroupDotHidden {
    if ([[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]] > 0) {
        [self.dotImage removeFromSuperview];
        self.dotImage = [[UIImageView alloc] init];
        self.dotImage.backgroundColor = MO_APP_TextColor_red;
        CGRect tabFrame = self.tabBar.frame;
        CGFloat x = SCREEN_WIDTH / 2 + 10;
        CGFloat y = ceilf(0.12 * tabFrame.size.height);
        self.dotImage.frame = CGRectMake(x, y, 8, 8);
        self.dotImage.layer.cornerRadius = 4;
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
