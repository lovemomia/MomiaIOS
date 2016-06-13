//
//  ChatUserFeedPhotoCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/11.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatUserFeedPhotoCell.h"

@implementation ChatUserFeedPhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(NSArray *)imgs {
    for (UIView * view in self.contentView.subviews) {
        if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *title = [UILabel new];
    title.text = @"成长说";
    title.textColor = UIColorFromRGB(0x333333);
    title.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *lastView;
    int photoWidth = (SCREEN_WIDTH - 140) / 4;
    for (int i = 0; i < imgs.count; i++) {
        UIImageView *photo = [UIImageView new];
        [photo sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        [self.contentView addSubview:photo];
        [photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo([NSNumber numberWithInt:photoWidth]);
            make.height.equalTo([NSNumber numberWithInt:photoWidth]);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(8);
            } else {
                make.left.equalTo(title.mas_right).offset(20);
            }
            make.centerY.equalTo(self.contentView);
        }];
        lastView = photo;
    }
    
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    int photoWidth = (SCREEN_WIDTH - 140) / 4;
    return photoWidth + 20;
}

@end
