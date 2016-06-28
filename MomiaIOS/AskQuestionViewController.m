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
#import "AccountService.h"

@interface AskQuestionViewController ()

@property (nonatomic,strong) NSNumber *wid;

@end

@implementation AskQuestionViewController


- (BOOL)isNavDarkStyle {
    return YES;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        [self decoderParams:params];
    }
    return self;
}

-(void)decoderParams:(NSDictionary *)params{
    self.wid = [params objectForKey:@"wid"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提问";
    
    NSDictionary *props = @{@"wid" : self.wid,@"uid": [AccountService defaultService].account.uid};
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/audio/askQuestion.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"AskQuestionComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
