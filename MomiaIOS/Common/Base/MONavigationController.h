//
//  MONavigationController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MONavigationController : UINavigationController {
    BOOL _changing;
}

@property(nonatomic, retain)UIView *alphaView;

-(void)setAlph;
//- (void)showNavigationBar;
//- (void)hideNavigationBar;

@end
