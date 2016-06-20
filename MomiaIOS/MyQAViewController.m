//
//  MyQAViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/19.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MyQAViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface MyQAViewController ()

@end

@implementation MyQAViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问答详情";
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/mine/myqadetail.bundle?platform=ios"];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"MyQADetaiComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
