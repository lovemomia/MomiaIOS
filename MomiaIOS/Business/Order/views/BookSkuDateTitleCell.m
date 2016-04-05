//
//  ProductCalendarTitleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BookSkuDateTitleCell.h"
#import "StringUtils.h"

@interface BookSkuDateTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation BookSkuDateTitleCell

-(void)setData:(NSString *)model
{
    if(model.length > 0) {
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [inputFormatter dateFromString:model];
        
        // 出生日期转换 年月日
        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
        
        [self.monthLabel setText:[NSString stringWithFormat:@"%ld月",(long)components1.month]];
        [self.dayLabel setText:[NSString stringWithFormat:@"%ld号",(long)components1.day]];
        [self.timeLabel setText:[NSString stringWithFormat:@"星期%@",[StringUtils stringForWeekday:components1.weekday]]];
        
    } else {
        [self.monthLabel setText:@""];
        [self.dayLabel setText:@""];
        [self.timeLabel setText:@""];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
