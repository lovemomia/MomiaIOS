//
//  CustomDarkButton.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CustomDarkButton.h"
#import "UIImage+Color.h"

@implementation CustomDarkButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer setCornerRadius:5];
        [self setBackgroundImage:[UIImage imageWithColor:MO_APP_ThemeColor size:CGSizeMake(SCREEN_WIDTH - 2 * 18, 45)] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [self.layer setCornerRadius:5];
    [self setBackgroundImage:[UIImage imageWithColor:MO_APP_ThemeColor size:frame.size] forState:UIControlStateNormal];
}

@end
