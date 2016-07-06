//
//  MyAccountViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/19.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MyAssetViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface MyAssetViewController ()

@end

@implementation MyAssetViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *props = @{@"utoken": [AccountService defaultService].account.token};
    
    self.title = @"我的账户";
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/mine/myasset.bundle?platform=ios",RNHost]];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"MyAssetComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
