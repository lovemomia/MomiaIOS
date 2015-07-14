//
//  FillOrderTopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderTopCell.h"
#import "FillOrderModel.h"

@interface FillOrderTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation FillOrderTopCell

-(void)setData:(FillOrderSkuModel *)model;
{
    NSString * stockStr = @"";
    
    if(model.type == 1) {//无上限，不显示stock
        if(model.limit ==0) {//每人不限单购买
            
        } else {//每人限单购买
            stockStr = [stockStr stringByAppendingFormat:@"每人限%ld单",model.limit];
        }
        
    } else {//有上限
        if(model.stock == 0) {//名额已满
            stockStr = [stockStr stringByAppendingString:@"名额已满"];
        } else {//还剩XX名额
            stockStr = [stockStr stringByAppendingFormat:@"仅剩%ld名额",model.stock];
        }
        
        if(model.limit == 0) {//每人不限单购买
            
        } else {//每人限单购买
            stockStr = [stockStr stringByAppendingFormat:@",每人限%ld单",model.limit];
        }
        
    }
    
    self.timeLabel.text = model.time;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f起",model.minPrice];
    
    self.stockLabel.text = stockStr;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
