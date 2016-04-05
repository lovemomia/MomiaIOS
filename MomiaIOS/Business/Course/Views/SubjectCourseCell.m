//
//  SubjectCourseCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "SubjectCourseCell.h"
#import "Course.h"

@implementation SubjectCourseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Course *)data {
    self.titleLabel.text = data.title;
    self.ageLabel.text = data.age;
    self.joinedLabel.text = [NSString stringWithFormat:@"%@人参加", data.joined];
    [self.coverIv sd_setImageWithURL:[NSURL URLWithString:data.cover]];
}

@end
