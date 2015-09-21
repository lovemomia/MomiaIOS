//
//  FeedZanCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedZanCell.h"

@interface FeedZanCell()

@end

@implementation FeedZanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onZanClicked:(id)sender {
    if (self.blockOnZanClicked) {
        self.blockOnZanClicked();
    }
}

- (void)setData:(FeedStarList *)data {
    [self.avatarsView removeAllSubviews];
    int maxNum = 6;
    int height = 38;
    for (int i = 0; i < data.list.count; i++) {
        if(i < maxNum) {
            FeedStar *item = data.list[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (height + 5) * i, 0, height, height)];
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = height/2;
            [imgView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
            [self.avatarsView addSubview:imgView];
        }
    }
    [self.zanLabel setText:[NSString stringWithFormat:@"%@", data.totalCount]];
}

@end
