//
//  MOBarButtonItem.m
//  MomiaIOS
//
//  Created by Owen on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOBarButtonItemView.h"

#define iconLength 25
#define kPadding 5


@interface MOBarButtonItemView ()

@end

@implementation MOBarButtonItemView


-(instancetype)init
{
    self = [super init];
    if(self) {
        _iconImgView = [[UIImageView alloc] init];
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_iconImgView];
        [self addSubview:_contentLabel];
        
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(iconLength, iconLength));
            make.left.equalTo(self);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImgView.mas_right).with.offset(kPadding);
            make.centerY.equalTo(_iconImgView);
        }];
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
