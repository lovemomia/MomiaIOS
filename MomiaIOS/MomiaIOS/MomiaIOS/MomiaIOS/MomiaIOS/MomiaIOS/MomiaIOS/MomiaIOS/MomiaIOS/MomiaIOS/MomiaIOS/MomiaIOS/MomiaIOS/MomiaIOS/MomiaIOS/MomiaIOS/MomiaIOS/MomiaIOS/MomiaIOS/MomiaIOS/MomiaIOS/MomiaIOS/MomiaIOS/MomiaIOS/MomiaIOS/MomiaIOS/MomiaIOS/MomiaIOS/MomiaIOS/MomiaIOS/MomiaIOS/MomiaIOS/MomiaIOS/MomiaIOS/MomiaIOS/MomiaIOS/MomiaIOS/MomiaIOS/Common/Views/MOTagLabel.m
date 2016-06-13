//
//  MOTagLabel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTagLabel.h"

@implementation MOTagLabel

- (void)setText:(id)text {
    NSArray *tagIndexs = [self indexForTag:@"#" inText:text];
    if (tagIndexs.count > 1) {
        [super setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = NSMakeRange([[tagIndexs objectAtIndex:0] integerValue],[[tagIndexs objectAtIndex:1] integerValue] - 2);
            
            //                UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:contentFontSize];
            //                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            //                if (font) {
            //                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
            //                    CFRelease(font);
            //                }
            
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:MO_APP_ThemeColor range:boldRange];
            
            return mutableAttributedString;
        }];
        
    } else {
        [super setText:text];
    }
}

- (NSArray *)indexForTag:(NSString *)tag inText:(NSString *)text {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i =0; i < [text length]; i++)
    {
        NSString *temp = [text substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:tag]) {
            [array addObject:[[NSNumber alloc] initWithInt:i]];
        }
    }
    return array;
}

@end
