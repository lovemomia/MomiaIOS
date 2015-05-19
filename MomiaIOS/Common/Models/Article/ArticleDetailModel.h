//
//  ArticleDetailModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleDetailContentImage : JSONModel

@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;

@end

@interface ArticleDetailContentItem : JSONModel

@property (strong, nonatomic) ArticleDetailContentImage<Optional> *image;
@property (strong, nonatomic) NSString<Optional> *text;


@end

@protocol ArticleDetailContentItem
@end

@interface ArticleDetailData : JSONModel

@property (assign, nonatomic) int articleId;
@property (strong, nonatomic) NSString *coverPhoto;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *abstracts;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *authorAccount;
@property (strong, nonatomic) NSString *authorDesc;
@property (strong, nonatomic) NSString *authorIcon;
@property (assign, nonatomic) int favNum;
@property (assign, nonatomic) BOOL favStatus;
@property (assign, nonatomic) int upNum;
@property (assign, nonatomic) BOOL upStatus;
@property (strong, nonatomic) NSArray<ArticleDetailContentItem>* content;

@end

@interface ArticleDetailModel : BaseModel

@property (strong, nonatomic) ArticleDetailData *data;

@end
