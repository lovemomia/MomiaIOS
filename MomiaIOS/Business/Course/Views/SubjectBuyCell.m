//
//  SubjctBuyCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectBuyCell.h"
#import "Subject.h"
#import "Course.h"
#import "StringUtils.h"

@interface SubjectBuyCell()

@end

@implementation SubjectBuyCell

- (void)awakeFromNib {
    // Initialization code
    self.buyButton.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(id)data {
    if ([data isKindOfClass:[Subject class]]) {
        Subject *subject = data;
        self.priceLabel.text = [StringUtils stringForPrice:subject.price];
        
        if ([subject.status intValue] == 1) {
            self.buyButton.enabled = YES;
            [self.buyButton setTitle:@"立即抢购" forState:UIControlStateNormal];
        } else {
            self.buyButton.enabled = NO;
            [self.buyButton setTitle:@"名额已满" forState:UIControlStateDisabled];
        }
        self.unitLabel.text = [NSString stringWithFormat:@"起／%@", subject.cheapestSkuTimeUnit];
        self.chooseLabel.text = subject.cheapestSkuDesc;
        
    } else {
        Course *course = data;
        if ([course.buyable boolValue]) {
            // 单次课程
            self.priceLabel.text = [StringUtils stringForPrice:course.price];
            self.unitLabel.text = @"／次";
            self.chooseLabel.text = @"";
            
        } else {
            self.priceLabel.text = [StringUtils stringForPrice:course.price];
            self.unitLabel.text = [NSString stringWithFormat:@"起／%@", course.cheapestSkuTimeUnit];
            self.chooseLabel.text = course.cheapestSkuDesc;
        }
        
        if ([course.status intValue] == 1) {
            self.buyButton.enabled = YES;
            [self.buyButton setTitle:@"立即抢购" forState:UIControlStateNormal];
        } else {
            self.buyButton.enabled = NO;
            [self.buyButton setTitle:@"名额已满" forState:UIControlStateDisabled];
        }
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 64;
}

@end
