//
//  FillOrderBottomCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderBottomCell.h"

@interface FillOrderBottomCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FillOrderBottomCell

-(void)setData:(FillOrderContactsModel *)model withIndex:(NSInteger)index andPersonStr:(NSString *)personStr andSkuModel:(FillOrderSkuModel *) skuModel
{
    if(index == 0 && skuModel.needRealName) {
        self.titleLabel.text = @"出行人";
        self.contentLabel.text = personStr;
    } else {
        self.titleLabel.text = @"联系人信息";
        self.contentLabel.text = model.mobile;
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
