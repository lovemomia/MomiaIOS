//
//  WendaHomeViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/13.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaHomeViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaHomeViewController ()

@property (nonatomic, strong)RCTRootView *rootView;

@end

@implementation WendaHomeViewController

- (BOOL)isNavDarkStyle {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"松果课堂";
    
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    // For production use, this `NSURL` could instead point to a pre-bundled file on disk: //
    //    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    // To generate that file, run the curl command and add the output to your main Xcode build target: //
    // curl http://localhost:8081/home/home.ios.bundle -o ./ReactComponent/output/main.jsbundle
//    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    self.rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WDHomeComponent" initialProperties:nil launchOptions:nil];
    self.rootView.frame = self.view.bounds;
    [self.view addSubview:self.rootView];
    
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
