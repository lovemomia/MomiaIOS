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
#import "PlaymateViewController.h"
#import "MineViewController.h"
#import "UIImage+Color.h"

@interface MORootViewController ()<UITabBarControllerDelegate> {
    
}
@property (nonatomic, strong) HomeViewController *home;
@property (nonatomic, strong) PlaymateViewController *playmate;
@property (nonatomic, strong) MineViewController *mine;

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
        
        _home = [[HomeViewController alloc]initWithParams:nil];
        _home.tabBarItem.title = @"精选";
        _home.tabBarItem.image = [UIImage imageNamed:@"nav_fav"];
        
//        _playmate = [[PlaymateViewController alloc]initWithParams:nil];
//        _playmate.tabBarItem.title = @"玩伴";
//        _playmate.tabBarItem.image = [UIImage imageNamed:@"nav_fav"];
        
        _mine = [[MineViewController alloc]initWithParams:nil];
        _mine.tabBarItem.title = @"我的";
        _mine.tabBarItem.image = [UIImage imageNamed:@"nav_fav"];
        
        MONavigationController *navHome = [[MONavigationController alloc] initWithRootViewController:_home];
//        MONavigationController *navPlaymate = [[MONavigationController alloc] initWithRootViewController:_playmate];
        MONavigationController *navMine = [[MONavigationController alloc] initWithRootViewController:_mine];
        
        self.viewControllers = [NSArray arrayWithObjects:
                                navHome,
//                                navPlaymate,
                                navMine,
                                nil];
        
        self.delegate = self;
    }
    return self;
}

- (void)makeTabBarHidden:(BOOL)hide {
    if ( [self.view.subviews count] < 2 )
        return;
    
    UIView *contentView;
    
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hide ){
        contentView.frame = self.view.bounds;
    }
    else{
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    
    self.tabBar.hidden = hide;
}

@end
