//
//  HomeEventCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "HomeEventCell.h"
#import "IndexModel.h"

@interface HomeEventCell()
@property (nonatomic, strong) IndexEvent *leftEvent;
@property (nonatomic, strong) IndexEvent *rightEvent;
@end

@implementation HomeEventCell
@synthesize leftEvent;
@synthesize rightEvent;

- (void)awakeFromNib {
    // Initialization code
    
    self.leftDescLabel.layer.borderColor = [MO_APP_ThemeColor CGColor];
    self.leftDescLabel.layer.borderWidth = 1.0f;
    self.leftDescLabel.layer.cornerRadius = 8.0;
    self.leftDescLabel.layer.masksToBounds = YES;
    
    self.rightDescLabel.layer.borderColor = [MO_APP_TextColor_red CGColor];
    self.rightDescLabel.layer.borderWidth = 1.0f;
    self.rightDescLabel.layer.cornerRadius = 8.0;
    self.rightDescLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onLeftClicked:(id)sender {
    if (leftEvent) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:leftEvent.action]];
    }
}

- (IBAction)onRightClicked:(id)sender {
    if (rightEvent) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:rightEvent.action]];
    }
}

- (void)setData:(IndexModel *)model {
    NSArray<IndexEvent> *events = model.data.events;
    if (events.count < 2) {
        return;
    }
    
    self.leftEvent = events[0];
    self.rightEvent = events[1];
    
    self.titleLabel.text = model.data.eventsTitle;
    
    self.leftTitleLabel.text = leftEvent.title;
    self.leftDescLabel.text = [NSString stringWithFormat:@"  %@  ", leftEvent.desc];
    [self.leftIcon sd_setImageWithURL:[NSURL URLWithString:leftEvent.img]];
    
    self.rightTitleLabel.text = rightEvent.title;
    self.rightDescLabel.text = [NSString stringWithFormat:@"  %@  ", rightEvent.desc];
    [self.rightIcon sd_setImageWithURL:[NSURL URLWithString:rightEvent.img]];
    
}

@end
