//
//  BookSkuItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/20.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookSkuItemCell.h"
#import "CourseSkuListModel.h"
#import "MOStepperView.h"

@implementation BookSkuItemCell

- (void)awakeFromNib {
    // Initialization code
    
    UILabel *label = [UILabel new];
    label.text = @"已满";
    label.font = [UIFont systemFontOfSize:15.0];
    label.backgroundColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 20));
            make.top.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
        }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CourseSku *)data {
    
    _steperView.maxValue = 10;
    _steperView.minValue = 0;
    _steperView.currentValue = 0;
    _steperView.plusEnabled = YES;
    _steperView.onclickStepper = ^(NSUInteger i){
        
    };
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
