//
//  PlaymateUgcCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedUgcCell.h"
#import "Feed.h"

@implementation FeedUgcCell

- (void)awakeFromNib {
    // Initialization code
    [self.commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
    [self.zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCommentBtnClick:(id)sender {
}

- (IBAction)onZanBtnClick:(id)sender {
}

-(void)setData:(Feed *)data {
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@", data.commentCount] forState:UIControlStateNormal];
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%@", data.starCount] forState:UIControlStateNormal];
}

@end
