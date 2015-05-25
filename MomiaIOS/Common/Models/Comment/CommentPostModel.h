//
//  CommentPostModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface CommentPostData : JSONModel

@property (strong, nonatomic) NSString<Optional> *author;
@property (strong, nonatomic) NSString<Optional> *authorIcon;
@property (strong, nonatomic) NSString<Optional> *content;
@property (strong, nonatomic) NSString<Optional> *time;
@property (assign, nonatomic) int commentId;

@end


@interface CommentPostModel : BaseModel

@property(nonatomic,strong) CommentPostData * data;

@end
