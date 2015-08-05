//
//  MOViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "MONavigationController.h"
#import "URLMappingManager.h"
#import "MORootViewController.h"
#import "HomeViewController.h"
#import "PlaymateViewController.h"
#import "MineViewController.h"

@interface MOViewController ()
@property (nonatomic, assign) BOOL addShadow;
@end

@implementation MOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MO_APP_VCBackgroundColor;
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.addShadow == NO && [self isNavTransparent] == NO) {
        UIImageView *shadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        shadow.image = [UIImage imageNamed:@"BgTitleShadow"];
        [self.view addSubview:shadow];
        self.addShadow = YES;
    }
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    if(MO_OS_VERSION >= 7.0)
    {
        MONavigationController *navController = (MONavigationController *)self.navigationController;
        if([self isNavTransparent] == NO) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            if([self isNavDarkStyle]) {
                [navController setDarkTitleStyle];
                
            } else {
                [navController setLightTitleStyle];
            }
            
        } else {
            [navController hideNavigationBar];
            
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
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
    self.navBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
//    self.navBackView.backgroundColor = MO_APP_NaviColor;
    self.navBackView.image = [UIImage imageNamed:@"bg_nav"];
    self.navBackView.alpha = 0;
    [self.view addSubview:self.navBackView];
}

- (void)addHeaderMaskView {
    CGRect frame = self.navigationController.navigationBar.frame;
    UIImageView *muskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 64)];
    muskView.image = [UIImage imageNamed:@"bg_nav_mask"];
    [self.view addSubview:muskView];
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:nil bundle:nil]) {
        // todo
        if (![self isKindOfClass:[HomeViewController class]] && ![self isKindOfClass:[MineViewController class]] && ![self isKindOfClass:[PlaymateViewController class]]) {
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    return self;
}

/* 是否透明导航栏 */
- (BOOL)isNavTransparent {
    return NO;
}

- (BOOL)isNavDarkStyle {
    return NO;
}

- (BOOL)openURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    return [[UIApplication sharedApplication ] openURL:url];
}

- (BOOL)openURL:(NSString *)urlStr byNav:(UINavigationController *)nav {
    NSURL *url = [NSURL URLWithString:urlStr];
    return [[URLMappingManager sharedManager] handleOpenURL:url byNav:nav];
}

- (BOOL)presentURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    return [[URLMappingManager sharedManager] presentURL:url byParent:self animated:YES];
}

- (void)showDialogWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}

- (void)showDialogWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alter.tag = tag;
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
