//
//  WendaQuestionListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaQuestionListViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaQuestionListViewController ()
@property (nonatomic, strong) NSString *wid;
@end

@implementation WendaQuestionListViewController

- (BOOL)isNavDarkStyle {
    return YES;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.wid = [params objectForKey:@"wid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"问题列表";
    
//    NSURL *jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/wenda/wdquestionlist.bundle?platform=ios",RNHost]];
    // For production use, this `NSURL` could instead point to a pre-bundled file on disk: //
    //    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    // To generate that file, run the curl command and add the output to your main Xcode build target: //
    // curl http://localhost:8081/home/home.ios.bundle -o ./ReactComponent/output/main.jsbundle
//     NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    
    NSURL *jsCodeLocation = nil;
    if ( MO_DEBUG == 0 || MO_DEBUG == 3) { //release 版本
        jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    } else {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8081/index.ios.bundle?platform=ios",RNHost]];
    }
    
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WDQuestionListComponent" initialProperties:@{@"wid" : (self.wid ? self.wid : @"0")} launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
