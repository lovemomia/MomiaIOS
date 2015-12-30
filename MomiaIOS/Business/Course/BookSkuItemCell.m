//
//  BookSkuItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/20.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookSkuItemCell.h"
#import "CourseSkuListModel.h"

@implementation BookSkuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CourseSku *)data {
    self.titleLabel.text = data.place.name;
    self.addressLabel.text = data.place.address;
    if ([data.closed boolValue]) {
        self.countLabel.text = @"已截止";
        self.countLabel.textColor = UIColorFromRGB(0x999999);
        
    } else if ([data.stock intValue] == 0) {
        self.countLabel.text = @"已报满";
        self.countLabel.textColor = UIColorFromRGB(0x999999);
        
    } else if ([data.stock intValue] <= 20) {
        self.countLabel.text = [NSString stringWithFormat:@"仅剩%@个名额", data.stock];
        self.countLabel.textColor = UIColorFromRGB(0xF67531);
        
    } else {
        self.countLabel.text = @"";
    }
    self.timeLabel.text = data.time;
}

@end
