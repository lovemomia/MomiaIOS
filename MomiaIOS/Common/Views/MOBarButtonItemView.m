//
//  MOBarButtonItem.m
//  MomiaIOS
//
//  Created by Owen on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOBarButtonItemView.h"

#define iconLength 16
#define kPadding 10
#define contentFont [UIFont systemFontOfSize:15.0f]

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
+(CGFloat) widthWithContent:(NSString *)content
{
    CGFloat width = 0;
    width += iconLength;
    width += kPadding;
    CGRect textRect = [UILabel widthForMutableString:content withHeight:20  lineSpace:0 andFont:contentFont];
    width += textRect.size.width;
    return width;

}


+(CGFloat) widthWithArticleData:(ArticleDetailData *)data withContentStyle:(ContentStyle) style
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
    CGRect textRect = [UILabel widthForMutableString:contentStr withHeight:20  lineSpace:0 andFont:contentFont];
    width += textRect.size.width;
    return width;

}

+(CGFloat) widthWithGoodsData:(GoodsDetailData *)data withContentStyle:(ContentStyle) style
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
    CGRect textRect = [UILabel widthForMutableString:contentStr withHeight:20  lineSpace:0 andFont:contentFont];
    width += textRect.size.width;
    return width;
    
}

+(CGFloat) widthWithArticleTopicData:(ArticleTopicData *)data
{
    CGFloat width = 0;
    width += iconLength;
    width += kPadding;
    NSString * contentStr = @"";
    contentStr = [NSString stringWithFormat:@"%d",data.favNum];
    CGRect textRect = [UILabel widthForMutableString:contentStr withHeight:20  lineSpace:0 andFont:contentFont];
    width += textRect.size.width;
    return width;
}

+(CGFloat) widthWithGoodsTopicData:(GoodsTopicData *)data
{
    CGFloat width = 0;
    width += iconLength;
    width += kPadding;
    NSString * contentStr = @"";
    contentStr = [NSString stringWithFormat:@"%d",data.favNum];
    CGRect textRect = [UILabel widthForMutableString:contentStr withHeight:20  lineSpace:0 andFont:contentFont];
    width += textRect.size.width;
    return width;
}




@end
