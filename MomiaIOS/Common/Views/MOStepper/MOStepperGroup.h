//
//  MOStepperGroup.h
//  MomiaIOS
//
//  Created by Owen on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOStepperView.h"

@interface MOStepperGroup : NSObject
@property(nonatomic,assign) NSUInteger maxPlaces;


-(MOStepperView *)objectAtIndex:(NSUInteger) index;
-(void)removeAllSteppers;
-(void)addMOStepperView:(MOStepperView *)stepperView;
-(void)refreshStatus;//更新array里边的stepper的plus状态

@end
