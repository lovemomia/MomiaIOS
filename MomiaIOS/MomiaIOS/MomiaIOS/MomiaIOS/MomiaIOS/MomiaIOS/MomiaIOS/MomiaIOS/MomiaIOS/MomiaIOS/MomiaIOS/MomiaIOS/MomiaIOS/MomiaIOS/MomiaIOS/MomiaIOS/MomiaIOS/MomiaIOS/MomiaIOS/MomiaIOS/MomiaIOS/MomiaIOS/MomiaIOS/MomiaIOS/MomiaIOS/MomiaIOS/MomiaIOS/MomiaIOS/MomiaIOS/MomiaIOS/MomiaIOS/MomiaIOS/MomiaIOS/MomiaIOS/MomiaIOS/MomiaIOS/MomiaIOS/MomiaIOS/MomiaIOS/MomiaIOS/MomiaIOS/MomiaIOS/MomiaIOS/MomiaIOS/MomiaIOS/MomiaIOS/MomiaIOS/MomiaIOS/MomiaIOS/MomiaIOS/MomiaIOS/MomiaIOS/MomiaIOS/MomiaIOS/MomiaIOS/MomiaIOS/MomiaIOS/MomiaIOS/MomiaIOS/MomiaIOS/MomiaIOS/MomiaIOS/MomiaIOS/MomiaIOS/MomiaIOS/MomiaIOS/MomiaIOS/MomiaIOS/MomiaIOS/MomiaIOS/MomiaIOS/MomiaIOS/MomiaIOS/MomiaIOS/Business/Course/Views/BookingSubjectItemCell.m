//
//  BookingSubjectItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookingSubjectItemCell.h"
#import "BookingSubjectListModel.h"

@implementation BookingSubjectItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(BookingSubject *)data {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:data.cover]];
    self.titleLabel.text = data.title;
    self.dateLabel.text = data.expireTime;
    self.descLabel.text = [NSString stringWithFormat:@"还可约%@次课", data.bookableCourseCount];
}

@end
