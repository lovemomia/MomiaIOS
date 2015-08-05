//
//  MOViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"


@interface MOViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *navBackView; // 导航条背景
- (void)addNavBackView;
- (void)addHeaderMaskView;

- (instancetype)initWithParams:(NSDictionary *)params;

- (BOOL)isNavTransparent;

- (BOOL)isNavDarkStyle;

- (BOOL)openURL:(NSString *)urlStr;

- (BOOL)openURL:(NSString *)urlStr byNav:(UINavigationController *)nav;

- (BOOL)presentURL:(NSString *)urlStr;

- (void)showDialogWithTitle:(NSString *)title message:(NSString *)message;

- (void)showDialogWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag;

@end
