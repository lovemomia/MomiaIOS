//
//  MONavigationController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MONavigationController : UINavigationController

@property(nonatomic, retain)UIView *backView;

- (void)setDarkTitleStyle;

- (void)setLightTitleStyle;

- (void)hideNavigationBar;

@end
