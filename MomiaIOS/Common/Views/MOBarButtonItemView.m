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
#define contentFont [UIFont systemFontOfSize:14.0f]

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
        [_contentLabel setFont:contentFont];
        
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
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMe:)];
        [self addGestureRecognizer:gesture];
    
    }
    return self;
}

-(void)onClickMe:(UITapGestureRecognizer *)gesture
{
    [self.delegate tapMOBarButtonItemView:(MOBarButtonItemView *)gesture.view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat) widthWithData:(ArticleDetailData *)data withContentStyle:(ContentStyle) style
{
    CGFloat width = 0;
    width += iconLength;
    width += kPadding;
    NSString * contentStr = @"";
    if(style == ContentStyleFavourite) {
        contentStr = [NSString stringWithFormat:@"%d",data.favNum];
    } else if(style == ContentStyleUp){
        contentStr = [NSString stringWithFormat:@"%d",data.upNum];
    }
    CGRect textRect = [UILabel widthForMutableString:contentStr withHeight:20 andFont:contentFont];
    width += textRect.size.width;
    return width;

}






@end
