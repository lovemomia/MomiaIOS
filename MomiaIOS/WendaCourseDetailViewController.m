//
//  WendaCourseDetailViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/6/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaCourseDetailViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaCourseDetailViewController ()

@property (nonatomic, strong) NSNumber *wid;

@end

@implementation WendaCourseDetailViewController

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
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdcoursedetail.bundle?platform=ios",RNHost]];
//     NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WendaCourseDetailComponent" initialProperties:props launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
