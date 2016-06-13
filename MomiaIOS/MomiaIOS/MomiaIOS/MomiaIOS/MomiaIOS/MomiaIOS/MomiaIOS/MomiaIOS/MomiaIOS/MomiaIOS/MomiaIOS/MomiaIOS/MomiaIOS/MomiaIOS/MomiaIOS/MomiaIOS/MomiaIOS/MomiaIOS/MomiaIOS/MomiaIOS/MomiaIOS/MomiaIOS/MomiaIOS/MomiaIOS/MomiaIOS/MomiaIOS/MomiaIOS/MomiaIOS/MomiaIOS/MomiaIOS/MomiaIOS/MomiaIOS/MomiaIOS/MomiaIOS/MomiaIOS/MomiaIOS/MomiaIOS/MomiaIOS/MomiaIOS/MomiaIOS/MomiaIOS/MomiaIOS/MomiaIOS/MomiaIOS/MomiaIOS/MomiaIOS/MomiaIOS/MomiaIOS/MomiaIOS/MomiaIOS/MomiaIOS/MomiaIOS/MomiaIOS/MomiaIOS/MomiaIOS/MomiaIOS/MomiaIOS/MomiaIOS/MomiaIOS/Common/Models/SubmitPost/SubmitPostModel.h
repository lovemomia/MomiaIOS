//
//  SubmitPostModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface SubmitPostData : JSONModel


@end


@interface SubmitPostModel : BaseModel

@property(nonatomic,strong) SubmitPostData * data;

@end

