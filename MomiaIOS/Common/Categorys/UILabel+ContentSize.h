//
//  UILabel+ContentSize.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ContentSize)

- (CGSize)contentSize;

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width andFontSize:(CGFloat)fontSize;

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width andFont:(UIFont *)font;

+ (CGRect)widthForMutableString:(NSString *)contentString withHeight:(CGFloat)height andFont:(UIFont *)font;
@end
