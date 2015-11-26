//
//  SubjectTabCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectTabCell.h"

@interface SubjectTabCell()
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation SubjectTabCell

- (void)awakeFromNib {
    // Initialization code
    [self.tab1Btn setTitleColor:MO_APP_ThemeColor forState:UIControlStateSelected];
    [self.tab1Btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.tab2Btn setTitleColor:MO_APP_ThemeColor forState:UIControlStateSelected];
    [self.tab2Btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.tab3Btn setTitleColor:MO_APP_ThemeColor forState:UIControlStateSelected];
    [self.tab3Btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [self.tab1Btn setBackgroundImage:nil forState:UIControlStateSelected];
    [self.tab2Btn setBackgroundImage:nil forState:UIControlStateSelected];
    [self.tab3Btn setBackgroundImage:nil forState:UIControlStateSelected];
    
    self.tab1Btn.selected = YES;
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 - 2, SCREEN_WIDTH / 3, 2)];
        self.bottomView.backgroundColor = MO_APP_ThemeColor;
        [self.contentView addSubview:self.bottomView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data {
    self.index = data;
    
    [self setSelectedIndex:self.index];
}

- (void)setSelectedIndex:(NSNumber *)index {
    self.bottomView.left = [index intValue] * SCREEN_WIDTH / 3;
    
    if ([index intValue] == 0) {
        self.tab1Btn.selected = YES;
        self.tab2Btn.selected = NO;
        self.tab3Btn.selected = NO;
        
    } else if ([index intValue] == 1) {
        self.tab1Btn.selected = NO;
        self.tab2Btn.selected = YES;
        self.tab3Btn.selected = NO;
        
    } else {
        self.tab1Btn.selected = NO;
        self.tab2Btn.selected = NO;
        self.tab3Btn.selected = YES;
    }
}

- (IBAction)onTab1Clicked:(id)sender {
    [self setSelectedIndex:@0];
    if (self.delegate) {
        [self.delegate onTabChanged:0];
    }
}

- (IBAction)onTab2Clicked:(id)sender {
    [self setSelectedIndex:@1];
    if (self.delegate) {
        [self.delegate onTabChanged:1];
    }
}

- (IBAction)onTab3Clicked:(id)sender {
    [self setSelectedIndex:@2];
    if (self.delegate) {
        [self.delegate onTabChanged:2];
    }
}

@end
