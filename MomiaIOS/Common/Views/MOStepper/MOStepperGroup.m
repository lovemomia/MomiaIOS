//
//  MOStepperGroup.m
//  MomiaIOS
//
//  Created by Owen on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOStepperGroup.h"

@interface MOStepperGroup ()

@property(nonatomic,strong) NSMutableArray * array;
@property(nonatomic,assign) NSUInteger maxPlaces;

@end

@implementation MOStepperGroup

-(NSMutableArray *)array
{
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

-(void)addMOStepperView:(MOStepperView *)stepperView
{
    if(!stepperView.isAddedGroup) {
        [self.array addObject:stepperView];
        [stepperView setAddedGroup:YES];
    }
}

-(BOOL)isFullPlace//判断当前array里边的stepper当前值之和是否达到最大名额限制
{
    BOOL full = FALSE;
    NSUInteger sum = 0;
    for (int i = 0; i < self.array.count; i++) {
        MOStepperView * stepper = self.array[i];
        sum += stepper.currentValue;
    }
    if(sum == self.maxPlaces) {
        full = YES;
    }
    return full;
}


-(void)refreshStatus//更新array里边的stepper的plus状态
{
    if([self isFullPlace]) {
        for (int i = 0 ; i < self.array.count; i++) {
            MOStepperView * stepper = self.array[i];
            stepper.plusEnabled = NO;
        }
    } else {
        for (int i = 0 ; i < self.array.count; i++) {
            MOStepperView * stepper = self.array[i];
            stepper.plusEnabled = YES;
        }

    }
}

-(void)resetSteppers
{
    for(int i = 0; i < self.array.count; i++) {
        MOStepperView * stepper = self.array[i];
        stepper.currentValue = 0;
        stepper.plusEnabled = YES;
        stepper.addedGroup = NO;
    }
    [self.array removeAllObjects];
}


@end
