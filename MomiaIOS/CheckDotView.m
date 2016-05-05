//
//  CheckDotView.m
//  MomiaIOS
//
//  Created by mosl on 16/5/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CheckDotView.h"

@implementation CheckDotView
{
    CGPoint centerPoint;
    CGFloat radius;
}

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    centerPoint.x = rect.size.width / 2.0;
    centerPoint.y = rect.size.height / 2.0;
    radius = rect.size.width > rect.size.height ? rect.size.height / 2.0 : rect.size.width / 2.0;
    if (_isChecked == NO) {
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(contextRef, 1.0);
        
        CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 255.0, 1.0);
        CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, radius - 1, 0, 2 * M_PI, 0);
        CGContextDrawPath(contextRef, kCGPathStroke);
    } else {
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(contextRef, 1.0);
        
        CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 255.0, 1.0);
        CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, radius - 1, 0, 2 * M_PI, 0);
        CGContextDrawPath(contextRef, kCGPathStroke);
        
        CGContextSetRGBFillColor(contextRef, 0.0, 255.0, 0.0, 1.0);
        CGContextAddArc(contextRef, centerPoint.x, centerPoint.y, radius - 2, 0, 2 * M_PI, 0); //添加一个圆
        CGContextDrawPath(contextRef, kCGPathFill);//绘制填充
    }
}

-(void)checked {
    
    _isChecked = YES;
    [self setNeedsDisplay];
}

-(void)uncheck {
    
    _isChecked = NO;
    [self setNeedsDisplay];
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if( self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}


-(void)setUp {
    
}

@end
