//
//  SelectImage.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadImageModel.h"

typedef enum {
    UploadStatusFail   = -1,
    UploadStatusIdle   = 0,
    UploadStatusGoing  = 1,
    UploadStatusFinish = 2
} UploadStatus; // 图片上传状态

@interface SelectImage : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumb;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) UploadStatus uploadStatus;
@property (strong, nonatomic) UploadImageData *respData;

@end
