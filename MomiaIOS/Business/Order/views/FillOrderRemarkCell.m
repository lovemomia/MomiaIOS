//
//  FillOrderRemarkCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderRemarkCell.h"
#import "UITextView+Placeholder.h"

@implementation FillOrderRemarkCell

#pragma mark - methods added by Owen

+(CGFloat)height
{
    return 50;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    [self.remarkTextView addPlaceHolder:placeHolder];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
