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
//    [loadingView centerToView:self];
    [self addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
- (void)removeLoadingBee{
    for ( UIView* loadingView in [self subviews]){
        if ([loadingView isKindOfClass:[UIActivityIndicatorView class]]) {
            [loadingView removeFromSuperview];
//            break;
        }
    }
}

- (void)showError:(NSString *)errMsg retry:(BlockOnRetryButtonClicked)retry {
    [self showError:errMsg retryTitle:@"重试" withBlock:retry];
}

- (void)showError:(NSString *)errMsg retryTitle:(NSString *)title withBlock:(BlockOnRetryButtonClicked)retry {
    UIView *view = [[UIView alloc] init];
    view.tag = -100;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = errMsg;
    label.textColor =  UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    UIButton *button = [[UIButton alloc]init];
    [button addAction:^(UIButton *btn) {
        retry();
    } forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundImage:[UIImage imageNamed:@"BgMediumButtonNormal"] forState:UIControlStateNormal];
    
    [view addSubview:label];
    [view addSubview:button];
    [self addSubview:view];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(0);
        make.left.equalTo(view.mas_left).with.offset(0);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.centerX.equalTo(view.mas_centerX);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@280);
        make.height.equalTo(@40);
        make.top.equalTo(label.mas_bottom).with.offset(40);
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.top.equalTo(self).with.offset(120);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
    }];
}

- (void)removeError {
    for (UIView *errorView in [self subviews]){
        if (errorView.tag == -100) {
            [errorView removeFromSuperview];
            break;
        }
    }
}

- (void)showEmptyView:(NSString *)msg tipLogo:(UIImage *)logo {
    UIView *view = [[UIView alloc] init];
    view.tag = -101;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = msg;
    label.textColor =  UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    
    UIImageView *logoIv = [[UIImageView alloc]init];
    logoIv.image = logo;
    
    [view addSubview:logoIv];
    [view addSubview:label];
    [self addSubview:view];
    
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.left.equalTo(view.mas_left);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoIv.mas_right).offset(10);
        make.right.equalTo(view.mas_right);
        make.centerY.equalTo(logoIv.mas_centerY);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@80);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(100);
    }];
}

- (void)showEmptyView:(NSString *)msg {
    [self showEmptyView:msg tipLogo:[UIImage imageNamed:@"IconCircleLogo"]];
}

- (void)removeEmptyView {
    for ( UIView* errorView in [self subviews]){
        if (errorView.tag == -101) {
            [errorView removeFromSuperview];
            break;
        }
    }
}

- (void)removeAllSubviews{
    for ( UIView* subview in [self subviews]){
        [subview removeFromSuperview];
    }
}

- (void)setBackgroundImage:(UIImage *)image {
    UIView *view = self.subviews.lastObject;
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        imageView.image = image;
    } else {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
    }
}

@end
