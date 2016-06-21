//
//  InsetsLabel.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/28.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
