//
//  MOButton.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOButton.h"

@implementation MOButton

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    CGFloat top = 15;
    CGFloat bottom = 15;
    CGFloat left = 15;
    CGFloat right = 15;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [super setBackgroundImage:image forState:state];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
