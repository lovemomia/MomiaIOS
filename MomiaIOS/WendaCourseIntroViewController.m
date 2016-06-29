//
//  WendaCourseIntroViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/23.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaCourseIntroViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaCourseIntroViewController ()

@property (nonatomic, strong) NSNumber *wid;

@end

@implementation WendaCourseIntroViewController


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
    self.wid = [params objectForKey:@"wid"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微课堂";
    
    NSDictionary *props = @{@"wid": self.wid};
    
    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdcourseintro.bundle?platform=ios",RNHost]];
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WendaCourseIntroComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
