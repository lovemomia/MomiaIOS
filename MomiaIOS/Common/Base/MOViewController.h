//
//  MOViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"


@interface MOViewController : UIViewController

@property (nonatomic, strong) UIView *navBackView; // 导航条背景
- (void)addNavBackView;

- (instancetype)initWithParams:(NSDictionary *)params;

- (BOOL)isNavTransparent;

- (BOOL)openURL:(NSString *)urlStr;

@end
