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

@property (nonatomic, strong) NSNumber *qid;

@end

@implementation AnswerAudioViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        [self decoderParams:params];
    }
    return self;
}

//解析参数
-(void)decoderParams:(NSDictionary *)params{
    self.qid = [params objectForKey:@"qid"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专家回答";
    
    NSDictionary *props = @{@"qid": self.qid};
    
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/audio/audioanswer.bundle?platform=ios",RNHost]];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AudioAnswerComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
