//
//  RecommendCell.m
//  MomiaIOS
//
//  Created by mosl on 16/5/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "RecommendCell.h"
#import "IndexModel.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img.layer.cornerRadius = 2;
    self.img.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    NSLog(@"select");
}

- (void)setData:(id)data {
    _data = data;
    
    IndexRecommend *indexRecommend = data;
    [self.img sd_setImageWithURL:[NSURL URLWithString:indexRecommend.cover]];
    self.title.text = indexRecommend.title;
    self.desc.text = indexRecommend.desc;
}

@end
