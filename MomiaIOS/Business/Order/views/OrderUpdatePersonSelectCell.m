//
//  OrderAddPersonSelectCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderUpdatePersonSelectCell.h"

@interface OrderUpdatePersonSelectCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation OrderUpdatePersonSelectCell

-(void)setData:(UpdatePersonModel *)model withIndex:(NSInteger) index
{
    if(index == 1) {
        self.titleLabel.text = @"性别";
        self.contentLabel.text = model.sex;
    } else if(index == 2) {
        self.titleLabel.text = @"出生日期";
        self.contentLabel.text = model.birthday;
    } else if(index == 3) {
        self.titleLabel.text = @"证件类型";
        if(model.idType == 1) self.contentLabel.text = @"身份证";
        else self.contentLabel.text = @"护照";
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
