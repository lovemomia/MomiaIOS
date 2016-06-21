//
//  UploadImageModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/20.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface UploadImageData : JSONModel

@property (strong, nonatomic) NSString* height;
@property (strong, nonatomic) NSString* width;
@property (strong, nonatomic) NSString* path;

@end

@interface UploadImageModel : BaseModel

@property (strong, nonatomic) UploadImageData* data;

@end
