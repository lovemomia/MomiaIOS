//
//  CheckBoxCell.m
//  MomiaIOS
//
//  Created by mosl on 16/5/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CheckBoxCell.h"

@implementation CheckBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDetailText:(NSString *)detailText{
    self.detailLabel.text = detailText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
