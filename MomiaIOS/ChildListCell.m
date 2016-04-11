//
//  WalkChildCellTableViewCell.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ChildListCell.h"

@interface  ChildListCell()

@property (nonatomic,weak) ChildListViewController* controller;

@end

@implementation ChildListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setData:(Child *)child delegate:(ChildListViewController *)controller{
    self.child = child;
    [self.name setText:child.name];
    [self.sex setText:child.sex];
    [self.age setText:[child ageWithDateOfBirth]];
    if (child.avatar && ![child.avatar isEqualToString:@""]) {
        NSURL *url = [[NSURL alloc]initWithString:child.avatar];
        [_avatar sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.avatar setImage:image];
        }];
    }
    self.controller = controller;
}

- (IBAction)editChildDetail:(id)sender {
    [self.controller openURL:[NSString stringWithFormat:@"childinfo?action=update&childId=%@",self.child.ids]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
