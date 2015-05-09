//
//  ArticleTopicHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleTopicHeaderCell.h"
#import "Constants.h"
#import "UILabel+ContentSize.h"

@implementation ArticleTopicHeaderCell
@synthesize coverIv;
@synthesize titleTv;
@synthesize introTv;

- (void)awakeFromNib {
    // Initialization code
    
//    CGFloat coverIvHeight = SCREEN_WIDTH * 0.72;
//    [coverIv setFrame:CGRectMake(0, 0, SCREEN_WIDTH, coverIvHeight)];
//    
//    [introTv setFrame: CGRectMake(introTv.frame.origin.x, introTv.frame.origin.y, [introTv contentSize].width, [introTv contentSize].height)];
//    
//    NSLog(@"coverIvHeight:%f", coverIvHeight);
//    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, coverIvHeight + [introTv contentSize].height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
