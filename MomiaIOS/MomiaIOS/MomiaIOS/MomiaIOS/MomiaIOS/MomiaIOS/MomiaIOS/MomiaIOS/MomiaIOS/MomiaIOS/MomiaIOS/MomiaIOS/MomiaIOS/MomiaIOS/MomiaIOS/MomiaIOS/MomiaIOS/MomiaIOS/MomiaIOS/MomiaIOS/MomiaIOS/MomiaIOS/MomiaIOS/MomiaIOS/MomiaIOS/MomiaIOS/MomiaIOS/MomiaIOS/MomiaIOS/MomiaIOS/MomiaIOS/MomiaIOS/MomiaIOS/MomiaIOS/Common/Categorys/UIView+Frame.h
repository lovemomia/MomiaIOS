//
//  UIView+Frame.h
//  MrEr
//
//  Created by Chuan on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BlockOnRetryButtonClicked)();

@interface UIView(BDPFrame)

@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) CGPoint centerPos;
@property (nonatomic, assign) float top;
@property (nonatomic, assign) float left;
@property (nonatomic, assign) float right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) float centerX;
@property (nonatomic, assign) float centerY;

- (float)width;
- (float)height;
- (float)posX;
- (float)posY;
- (CGPoint)brPos;
- (CGPoint)centerPos;
- (CGSize)size;
- (float)bottom;

- (void)setTop:(float)top;
- (void)setBottom:(float)bottom;
- (void)setWidth:(float)width;
- (void)setHeight:(float)height;
- (void)setPosX:(float)posx;
- (void)setPosY:(float)posy;
- (void)setLeft:(float)left;
- (void)setRight:(float)right;
- (void)centerToView:(UIView *)view;
- (void)centerToRect:(CGRect)rect;
- (void)setSize:(CGSize)size;

- (void)moveUp:(float)len;
- (void)moveRight:(float)len;

- (void)showLoadingBee;
- (void)removeLoadingBee;

- (void)showError:(NSString *)errMsg retryTitle:(NSString *)title withBlock:(BlockOnRetryButtonClicked)retry;
- (void)showError:(NSString *)errMsg retry:(BlockOnRetryButtonClicked)retry;
- (void)removeError;

- (void)showEmptyView:(NSString *)msg tipLogo:(UIImage *)logo;
- (void)showEmptyView:(NSString *)msg;
- (void)removeEmptyView;

- (void)removeAllSubviews;

- (void)setBackgroundImage:(UIImage *)image;

@end
