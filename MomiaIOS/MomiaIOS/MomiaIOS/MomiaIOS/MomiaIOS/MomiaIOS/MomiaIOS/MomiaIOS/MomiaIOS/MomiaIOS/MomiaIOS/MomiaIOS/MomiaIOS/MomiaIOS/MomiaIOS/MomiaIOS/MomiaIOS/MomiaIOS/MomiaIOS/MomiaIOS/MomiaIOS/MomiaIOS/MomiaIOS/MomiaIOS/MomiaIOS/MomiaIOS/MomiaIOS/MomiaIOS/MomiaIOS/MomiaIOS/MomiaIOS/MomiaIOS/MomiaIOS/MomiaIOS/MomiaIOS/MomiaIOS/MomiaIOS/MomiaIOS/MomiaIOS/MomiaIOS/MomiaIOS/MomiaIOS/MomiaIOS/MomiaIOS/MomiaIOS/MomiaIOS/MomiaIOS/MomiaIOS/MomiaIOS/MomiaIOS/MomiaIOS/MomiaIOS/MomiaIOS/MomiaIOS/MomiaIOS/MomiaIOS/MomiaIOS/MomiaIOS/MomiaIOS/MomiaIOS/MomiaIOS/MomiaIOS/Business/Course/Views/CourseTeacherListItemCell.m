//
//  CourseTeacherListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseTeacherListItemCell.h"
#import "CourseTeacherListModel.h"

@implementation CourseTeacherListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CourseTeacher *)data {
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:nil];
    self.nameLabel.text = data.name;
    self.eduLabel.text = data.education;
    self.expLabel.text = data.experience;
}

@end
