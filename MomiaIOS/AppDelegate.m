//
//  AppDelegate.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "URLMappingManager.h"
#import "MONavigationController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *root;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    HomeViewController *home = [[HomeViewController alloc]initWithParams:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.root = [[MONavigationController alloc]init];
    self.window.rootViewController = self.root;
    
    [self.root pushViewController:home animated:NO];
    [self.window makeKeyAndVisible];

    return YES;
}

/* For iOS 4.1 and earlier */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self handleOpenURL:url];
    
    return YES;
}

/* For iOS 4.2 and later */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [self handleOpenURL:url];
    
    return YES;
}

- (void)handleOpenURL:(NSURL *)url
{
    NSLog(@"openURL with url: %@", [url absoluteString]);
    
    [[URLMappingManager sharedManager] handleOpenURL:url byNav:self.root];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
