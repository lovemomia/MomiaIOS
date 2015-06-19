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

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width lineSpace:(CGFloat)space andFontSize:(CGFloat)fontSize;

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width lineSpace:(CGFloat)space andFont:(UIFont *)font;

//算一行的宽度
+ (CGRect)widthForMutableString:(NSString *)contentString withHeight:(CGFloat)height lineSpace:(CGFloat)space andFont:(UIFont *)font;


+ (CGRect)widthForAttributedString:(NSAttributedString *)contentString withHeight:(CGFloat)height;
@end
