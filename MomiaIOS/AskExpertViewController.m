//
//  AskExpertViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/24.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "AskExpertViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface AskExpertViewController ()

@end

@implementation AskExpertViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"问专家";
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdaskexpert.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AskExpertComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
