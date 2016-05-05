//
//  CheckDotView.h
//  MomiaIOS
//
//  Created by mosl on 16/5/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckDotView : UIView

@property(nonatomic,assign) BOOL isChecked;

-(void)checked;

-(void)uncheck;

@end
