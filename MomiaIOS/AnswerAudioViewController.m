//
//  AnswerAudioViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/14.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "AnswerAudioViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface AnswerAudioViewController ()

@end

@implementation AnswerAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/audio/AudioAnswer.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AudioAnswerComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
