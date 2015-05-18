//
//  MOViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "MONavigationController.h"

@interface MOViewController ()

@end

@implementation MOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(MO_OS_VERSION >= 7.0)
    {
        if([self isNavTransparent] == NO) {
            self.edgesForExtendedLayout =UIRectEdgeNone;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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

- (void)addNavBackView {
    CGRect frame = self.navigationController.navigationBar.frame;
    self.navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
    self.navBackView.backgroundColor = MO_APP_NaviColor;
    self.navBackView.alpha = 0;
    [self.view addSubview:self.navBackView];
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:nil bundle:nil]) {
        // todo
    }
    return self;
}

/* 是否透明导航栏 */
- (BOOL)isNavTransparent {
    return NO;
}

- (BOOL)openURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    return [[UIApplication sharedApplication ] openURL:url];
}

@end
