//
//  WendaCourseIntroViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/23.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaCourseIntroViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaCourseIntroViewController ()

@end

@implementation WendaCourseIntroViewController


- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微课堂";
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdcourseintro.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WendaCourseIntroComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
