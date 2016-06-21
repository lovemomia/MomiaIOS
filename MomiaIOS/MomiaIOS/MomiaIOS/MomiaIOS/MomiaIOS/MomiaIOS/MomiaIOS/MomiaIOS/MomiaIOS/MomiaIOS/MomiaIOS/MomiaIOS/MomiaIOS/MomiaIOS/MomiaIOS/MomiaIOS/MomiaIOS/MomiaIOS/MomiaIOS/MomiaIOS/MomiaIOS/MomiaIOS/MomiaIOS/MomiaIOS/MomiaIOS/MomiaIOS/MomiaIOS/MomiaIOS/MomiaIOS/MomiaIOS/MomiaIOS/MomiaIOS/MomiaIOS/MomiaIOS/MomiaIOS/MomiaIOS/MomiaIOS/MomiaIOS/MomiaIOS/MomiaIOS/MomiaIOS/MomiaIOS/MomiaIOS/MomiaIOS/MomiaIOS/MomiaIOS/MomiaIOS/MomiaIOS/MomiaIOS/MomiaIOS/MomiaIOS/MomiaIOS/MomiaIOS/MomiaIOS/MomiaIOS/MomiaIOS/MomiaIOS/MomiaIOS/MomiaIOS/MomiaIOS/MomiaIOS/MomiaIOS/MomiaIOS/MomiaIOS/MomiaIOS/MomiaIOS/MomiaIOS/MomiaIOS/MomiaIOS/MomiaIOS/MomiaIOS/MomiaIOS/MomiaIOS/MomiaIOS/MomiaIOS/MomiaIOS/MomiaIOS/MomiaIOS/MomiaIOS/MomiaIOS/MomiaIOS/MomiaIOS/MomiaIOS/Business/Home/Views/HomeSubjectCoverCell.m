//
//  HomeSubjectCoverCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "HomeSubjectCoverCell.h"

@implementation HomeSubjectCoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)data {
    [self.photoIv sd_setImageWithURL:[NSURL URLWithString:data]];
}

@end
