//
//  AskQuestionViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface AskQuestionViewController ()

@end

@implementation AskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提问";
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/audio/askQuestion.bundle?platform=ios"];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AskQuestionComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
