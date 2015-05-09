//
//  UIView+Frame.m
//  MrEr
//
//  Created by Chuan on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView+Frame.h"


@implementation UIView(BDPFrame)

@dynamic width, height,posX, posY, centerPos, top, right, left;

- (float)width
{
	return self.frame.size.width;
}

- (float)height
{
	return self.frame.size.height;
}

- (float)posX
{
	return self.frame.origin.x;
}

- (float)posY
{
	return self.frame.origin.y;
}

- (float)top{
    return self.frame.origin.y;
}

- (float)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (float)left{
    return self.posX;
}

- (float)right{
    return self.brPos.x;
}

- (CGSize)size{
    return CGSizeMake(self.width, self.height);
}

- (void)setSize:(CGSize)size{
    self.width = size.width;
    self.height = size.height;
}

- (CGPoint)brPos
{
	return CGPointMake([self posX]+[self width], [self posY]+[self height]);
}

- (float)centerX
{
    return self.center.x;
}
- (void)setCenterX:(float)centerX
{
    CGPoint centerPoint  = self.center;
    centerPoint.x = centerX;
    self.center = centerPoint;
}

- (float)centerY
{
    return self.center.y;
}

- (void)setCenterY:(float)centerY
{
    CGPoint centerPoint  = self.center;
    centerPoint.y = centerY;
    self.center = centerPoint;
}

- (CGPoint)centerPos
{
	return CGPointMake([self width]/2, [self height]/2);
}

- (void)setCenterPos:(CGPoint)pos{
    self.frame = CGRectMake(pos.x - self.width/2, pos.y - self.height/2, self.width, self.height);
}

- (void)setTop:(float)top{
    [self setPosY:top];
}

- (void)setBottom:(float)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setWidth:(float)width
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(float)height
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setPosX:(float)posx
{
	self.frame = CGRectMake(posx, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setLeft:(float)left{
    [self setPosX:left];
}

- (void)setRight:(float)right{
    [self setPosX:right-self.width];
}

- (void)setPosY:(float)posy
{
	self.frame = CGRectMake(self.frame.origin.x, posy, self.frame.size.width, self.frame.size.height);
}

- (void)moveUp:(float)len{
    self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y- len, self.frame.size.width, self.frame.size.height);
}

- (void)moveRight:(float)len{
    self.frame = CGRectMake(self.frame.origin.x + len, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)centerToView:(UIView *)view
{
    [self setPosX:([view width] - [self width])/2];
    [self setPosY:([view height] - [self height])/2];
}

- (void)centerToRect:(CGRect)rect{
    [self setPosX:(rect.size.width - [self width])/2];
    [self setPosY:(rect.size.height - [self height])/2];

}

- (void)showLoadingBee{
    UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [loadingView startAnimating];
    [loadingView centerToView:self];
    [self addSubview:loadingView];
}
- (void)removeLoadingBee{
    for ( UIView* loadingView in [self subviews]){
        if ([loadingView isKindOfClass:[UIActivityIndicatorView class]]) {
            [loadingView removeFromSuperview];
            break;
        }
    }
}

- (void)removeAllSubviews{
    for ( UIView* subview in [self subviews]){
        [subview removeFromSuperview];
    }
}

@end
