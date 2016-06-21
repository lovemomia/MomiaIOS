//
//  PackageHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "PackageHeaderCell.h"

@implementation PackageHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)data {
    self.packageNameLabel.text = [NSString stringWithFormat:@"%@课程包", data];
}

@end
