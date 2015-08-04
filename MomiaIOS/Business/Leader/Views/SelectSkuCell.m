//
//  SelectSkuCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/4.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SelectSkuCell.h"
#import "StringUtils.h"

@implementation SelectSkuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(LeaderSku *) model {
    if (model.hasLeader) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        self.leaderInfoLabel.text = model.leaderInfo;
        self.leaderInfoLabel.hidden = NO;
        
    } else {
        self.leaderInfoLabel.hidden = YES;
    }
    
    NSString * stockStr = @"";
    if (model.stock == 0) {
        stockStr = [stockStr stringByAppendingString:@"名额已满"];
    } else {
        stockStr = [stockStr stringByAppendingFormat:@"仅剩%ld名额", (long)model.stock];
    }
    
    if (model.desc.length > 0) {
        self.timeLabel.text = [model.time stringByAppendingFormat:@" (%@)", model.desc];
        
    } else {
        self.timeLabel.text = model.time;
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@起", [StringUtils stringForPrice:model.minPrice]];
    self.stockLabel.text = stockStr;
}

@end
