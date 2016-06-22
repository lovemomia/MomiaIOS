//
//  WendaCourseDetailViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaCourseDetailViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaCourseDetailViewController ()

@end

@implementation WendaCourseDetailViewController


- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微课堂";
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/wenda/wdcoursedetail.bundle?platform=ios"];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WendaCourseDetailComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
