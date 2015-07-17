//
//  ProductCalendarTitleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarTitleCell.h"

@interface ProductCalendarTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ProductCalendarTitleCell

-(void)setData:(ProductCalendarMonthDataModel *)model
{
    if(model.date.length > 0) {
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [inputFormatter dateFromString:model.date];
        
        // 出生日期转换 年月日
        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
        
        [self.monthLabel setText:[NSString stringWithFormat:@"%ld",(long)components1.month]];
        [self.dayLabel setText:[NSString stringWithFormat:@"%ld",(long)components1.day]];
        [self.timeLabel setText:[self stringOfWeekday:components1.weekday]];
        
    } else {
        [self.monthLabel setText:@""];
        [self.dayLabel setText:@""];
        [self.timeLabel setText:@""];
    }
}

-(NSString *)stringOfWeekday:(NSInteger) weekday
{
    NSString * str;
    switch (weekday) {
        case 1:
            str = @"日";
            break;
        case 2:
            str = @"一";
            break;
        case 3:
            str = @"二";
            break;
        case 4:
            str = @"三";
            break;
        case 5:
            str = @"四";
            break;
        case 6:
            str = @"五";
            break;
        case 7:
            str = @"六";
            break;
        default:
            str = @"?";
            break;
    }
    return [@"星期" stringByAppendingString:str];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
