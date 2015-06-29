//
//  MOStepper.h
//  MomiaIOS
//
//  Created by Owen on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnClickStepper)(NSUInteger currentValue);

@interface MOStepperView : UIView

@property(nonatomic,assign) NSUInteger currentValue;
@property(nonatomic,assign) NSUInteger maxValue;
@property(nonatomic,assign) NSUInteger minValue;

@property(nonatomic,strong) OnClickStepper onclickStepper;

@property(nonatomic,assign) BOOL plusEnabled;


@end
