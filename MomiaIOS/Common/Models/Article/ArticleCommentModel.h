//
//  ArticleCommentModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/15.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleCommentItem : JSONModel

@property (strong, nonatomic) NSString<Optional> *author;
@property (strong, nonatomic) NSString<Optional> *authorIcon;
@property (strong, nonatomic) NSString<Optional> *content;
@property (strong, nonatomic) NSString<Optional> *time;
@property (assign, nonatomic) int commentId;


@end

@protocol ArticleCommentItem
@end

@interface ArticleCommentData : JSONModel

@property (strong, nonatomic) NSArray<ArticleCommentItem>* commentList;

@end


@interface ArticleCommentModel : BaseModel

@property (strong, nonatomic) ArticleCommentData *data;


@end
