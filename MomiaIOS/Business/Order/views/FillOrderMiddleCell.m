//
//  FillOrderMiddleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderMiddleCell.h"
#import "StringUtils.h"

@interface FillOrderMiddleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation FillOrderMiddleCell




-(void)setData:(FillOrderPriceModel *)model
{
    NSString * content = @"";
    if(model.adult > 0) {
        content = [content stringByAppendingFormat:@"%ld成人",(long)model.adult];
    }
    if(model.child > 0) {
        content = [content stringByAppendingFormat:@"%ld儿童",(long)model.child];
    }
    content = [content stringByAppendingString:@":"];
        
    content = [content stringByAppendingFormat:@"￥%@/%@",[StringUtils stringForPrice:model.price],model.unit];
    
    self.titleLabel.text = content;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
