//
//  MyAnswerViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/19.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface MyAnswerViewController ()

@property (nonatomic, strong) NSString *utoken;

@end

@implementation MyAnswerViewController

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
    self.utoken = [params objectForKey:@"utoken"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我答";
    
    self.utoken = [AccountService defaultService].account.token;
    NSDictionary *props = @{@"utoken": self.utoken};
    
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/mine/myanswer.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"MyAnswerComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
