//
//  HomeViewController3.m
//  MomiaIOS
//
//  Created by mosl on 16/6/13.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "HomeViewController3.h"
#import "RCTRootView.h"
#import "RNCommon.h"
@interface HomeViewController3 ()

@end

@implementation HomeViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/audio/AudioAnswer.bundle?platform=ios"];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AudioAnswerComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
