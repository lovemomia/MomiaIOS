//
//  WendaCourseListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaCourseListViewController.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface WendaCourseListViewController ()

@property (nonatomic, strong) NSString *wid;

@end

@implementation WendaCourseListViewController

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
    
    self.navigationItem.title = @"微课列表";
    
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/wenda/wdcourselist.bundle?platform=ios"];
    // For production use, this `NSURL` could instead point to a pre-bundled file on disk: //
    //    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    // To generate that file, run the curl command and add the output to your main Xcode build target: //
    // curl http://localhost:8081/home/home.ios.bundle -o ./ReactComponent/output/main.jsbundle
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"WDCourseListComponent" initialProperties:@{@"wid" : (self.wid ? self.wid : @"0")} launchOptions:nil];
    rootView.frame = self.view.bounds; 
    [self.view addSubview:rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
