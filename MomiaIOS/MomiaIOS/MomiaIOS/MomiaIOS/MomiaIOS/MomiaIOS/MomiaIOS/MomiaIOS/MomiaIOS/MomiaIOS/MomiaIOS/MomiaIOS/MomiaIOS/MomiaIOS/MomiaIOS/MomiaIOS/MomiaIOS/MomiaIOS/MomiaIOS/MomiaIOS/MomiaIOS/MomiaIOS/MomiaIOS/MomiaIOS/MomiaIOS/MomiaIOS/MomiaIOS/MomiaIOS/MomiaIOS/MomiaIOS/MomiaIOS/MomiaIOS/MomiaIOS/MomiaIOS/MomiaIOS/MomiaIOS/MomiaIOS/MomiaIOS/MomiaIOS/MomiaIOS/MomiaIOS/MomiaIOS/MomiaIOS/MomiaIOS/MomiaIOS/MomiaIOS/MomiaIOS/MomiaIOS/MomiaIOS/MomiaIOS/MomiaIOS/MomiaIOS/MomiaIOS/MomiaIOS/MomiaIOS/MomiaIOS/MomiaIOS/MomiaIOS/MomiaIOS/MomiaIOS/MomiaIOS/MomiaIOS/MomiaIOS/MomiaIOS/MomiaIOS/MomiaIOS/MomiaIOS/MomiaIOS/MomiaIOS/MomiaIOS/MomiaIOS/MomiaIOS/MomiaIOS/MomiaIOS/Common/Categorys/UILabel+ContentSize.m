//
//  UILabel+ContentSize.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "UILabel+ContentSize.h"
#import <CoreText/CoreText.h>

@implementation UILabel (ContentSize)

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width lineSpace:(CGFloat)space andFontSize:(CGFloat)fontSize{
    if (!contentString) {
        return CGRectZero;
    }
    
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [mutString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    
    UIFont *aUiFont = [UIFont systemFontOfSize:fontSize];
    NSRange range = {0, contentString.length};
    [mutString addAttribute:(id)kCTFontAttributeName value:aUiFont range:range];
    
    CGRect rect = [mutString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect;
}

+ (CGRect)heightForMutableString:(NSString *)contentString withWidth:(CGFloat)width lineSpace:(CGFloat)space andFont:(UIFont *)font
{
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [mutString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    
    UIFont *aUiFont = font;
    NSRange range = {0, contentString.length};
    [mutString addAttribute:(id)kCTFontAttributeName value:aUiFont range:range];
    
    CGRect rect = [mutString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect;
}

+ (CGRect)widthForMutableString:(NSString *)contentString withHeight:(CGFloat)height lineSpace:(CGFloat)space andFont:(UIFont *)font
{
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [mutString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    
    UIFont *aUiFont = font;
    NSRange range = {0, contentString.length};
    [mutString addAttribute:(id)kCTFontAttributeName value:aUiFont range:range];
    
    CGRect rect = [mutString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect;
}

+ (CGRect)widthForAttributedString:(NSAttributedString *)contentString withHeight:(CGFloat)height
{
    CGRect rect = [contentString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect;
}



@end
