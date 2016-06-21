//
//  MOLabel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOLabel.h"

@implementation MOLabel

- (void)setText:(NSString *)text {
    if (text == nil) {
        [super setText:text];
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:MO_LABEL_LINE_SPACE];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
    [self sizeToFit];

}

@end
