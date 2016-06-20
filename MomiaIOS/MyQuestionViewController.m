//
//  MyQuestionViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/19.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface MyQuestionViewController ()

@end

@implementation MyQuestionViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我问";
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/mine/myquestion.bundle?platform=ios"];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"MyQuestionComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
