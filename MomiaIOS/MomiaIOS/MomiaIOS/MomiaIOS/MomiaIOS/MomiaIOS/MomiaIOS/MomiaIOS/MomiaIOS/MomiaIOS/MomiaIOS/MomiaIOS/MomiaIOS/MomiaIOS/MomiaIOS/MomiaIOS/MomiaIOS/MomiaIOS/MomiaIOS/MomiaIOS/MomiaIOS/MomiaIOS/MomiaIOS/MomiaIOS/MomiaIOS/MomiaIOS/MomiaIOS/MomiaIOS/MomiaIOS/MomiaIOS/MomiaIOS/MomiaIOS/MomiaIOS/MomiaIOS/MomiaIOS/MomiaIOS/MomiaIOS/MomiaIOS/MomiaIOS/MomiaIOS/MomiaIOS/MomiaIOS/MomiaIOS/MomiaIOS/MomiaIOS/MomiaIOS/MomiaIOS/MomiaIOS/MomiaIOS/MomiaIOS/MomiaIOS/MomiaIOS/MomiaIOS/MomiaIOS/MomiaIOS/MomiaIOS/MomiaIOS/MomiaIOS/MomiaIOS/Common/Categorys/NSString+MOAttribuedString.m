//
//  NSString+MOAttribuedString.m
//  MomiaIOS
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "NSString+MOAttribuedString.h"

@implementation NSString (MOAttribuedString)

-(NSAttributedString *)attributedStringWithColor:(UIColor *) color andFont:(UIFont *) font
{
    if(!color) {
        color = [UIColor blackColor];
    }
    if(!font) {
        font = [UIFont systemFontOfSize:17.0f];
    }
        
    NSDictionary * dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:self attributes:dic];
    return attributedString;
}


@end
