//
//  UIView+Border.h
//  MomiaIOS
//
//  Created by mosl on 16/4/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
