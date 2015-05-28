//
//  MOBarButtonItem.h
//  MomiaIOS
//
//  Created by Owen on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailModel.h"

@class MOBarButtonItemView;

typedef enum {
    ContentStyleFavourite,
    ContentStyleUp
} ContentStyle;

@protocol MOBarButtonItemViewDelegate <NSObject>

-(void)tapMOBarButtonItemView:(MOBarButtonItemView *)itemView;

@end

@interface MOBarButtonItemView : UIView

@property(nonatomic,strong) UIImageView * iconImgView;
@property(nonatomic,strong) UILabel * contentLabel;
@property(nonatomic,strong) id<MOBarButtonItemViewDelegate> delegate;

+(CGFloat) widthWithData:(ArticleDetailData *)data withContentStyle:(ContentStyle) style;

@end
