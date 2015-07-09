//
//  ProductPlayFellowCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductPlayFellowCell.h"
#import "NSDate+Age.h"

@interface ProductPlayFellowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ProductPlayFellowCell

-(void)setData:(PlayFellowPlaymatesModel *) model;
{
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = model.nickName;
    self.contentLabel.text = [self stringWithChildrenArray:model.children];
}

-(NSString *)stringWithChildrenArray:(NSArray *)array
{
    NSString * str = @"";
    for(int i = 0 ; i < array.count ; i++) {
        if(i == 2) break;
        str = [str stringByAppendingString:array[i]];
        str = [str stringByAppendingString:@" "];
    }
    return str;
    
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 23;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
