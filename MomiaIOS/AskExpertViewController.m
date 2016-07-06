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

@property (nonatomic, strong) NSNumber *qid;

@end

@implementation AskExpertViewController

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
    // Do any additional setup after loading the view.
    
    self.title = @"问专家";
    
    NSDictionary *props = @{@"qid": self.qid};
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdaskexpert.bundle?platform=ios",RNHost]];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AskExpertComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

//页面消失，得处理一些东西[语音播放停止]
- (void)viewWillDisappear:(BOOL)animated {
    
    //停止语音
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopAudio" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
