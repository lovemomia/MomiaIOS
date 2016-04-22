//
//  CaskBackStatusView.m
//  MomiaIOS
//
//  Created by mosl on 16/4/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CashBackStatusView.h"

@implementation CashBackStatusView

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    
//    // Draw them with a 2.0 stroke width so they are a bit more visible.
//    CGContextSetLineWidth(context, 2.0f);
//    
//    CGContextMoveToPoint(context, 0.0f, 0.0f); //start at this point
//    
//    CGContextAddLineToPoint(context, 20.0f, 20.0f); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, 0, 16);  // top left
    CGContextAddLineToPoint(ctx, 10, 0);
    CGContextAddLineToPoint(ctx, 91, 0);  // mid right
    CGContextAddLineToPoint(ctx, 91, 32);
    CGContextAddLineToPoint(ctx, 10, 32);  // bottom left
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 255.f / 255.f, 153.f /255.f, 51.f /255.f, 1);
    CGContextFillPath(ctx);
}

@end
