//
//  UIView+Border.m
//  MomiaIOS
//
//  Created by mosl on 16/4/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "UIView+Border.h"


@implementation UIView (Border)

@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
