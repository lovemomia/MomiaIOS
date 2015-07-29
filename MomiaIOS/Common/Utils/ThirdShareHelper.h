//
//  ThirdShareHelper.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface ThirdShareHelper : NSObject

- (void)shareToWechat:(NSString *)url thumbUrl:(NSString *)thumbUrl
                title:(NSString *)title desc:(NSString *)desc scene:(NSInteger)scene;

- (void)shareToWechat:(NSString *)url thumb:(UIImage *)thumb title:(NSString *)title desc:(NSString *)desc scene:(NSInteger)scene;

@end
