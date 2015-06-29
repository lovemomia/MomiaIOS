//
//  FillOrderMiddleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderMiddleCell.h"

@interface FillOrderMiddleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation FillOrderMiddleCell




-(void)setData:(FillOrderPriceModel *)model withCurrentValue:(NSUInteger) currentValue
{
    NSString * content = @"";
    if(model.adult > 0) {
        content = [content stringByAppendingFormat:@"%ld成人",model.adult];
    }
    if(model.child > 0) {
        content = [content stringByAppendingFormat:@"%ld儿童",model.child];
    }
    content = [content stringByAppendingString:@":"];
    
    content = [content stringByAppendingFormat:@"￥%.2f/%@",model.price,model.unit];
    
    self.titleLabel.text = content;
    
    self.stepperView.currentValue = currentValue;
        
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
