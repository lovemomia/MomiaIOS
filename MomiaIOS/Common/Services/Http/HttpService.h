//
//  HttpService.h
//  MomiaIOS
//
//  Http请求服务，封装了请求基本参数，header设置，请求缓存等，业务层不需要单独设置
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"


typedef void (^BlockMOHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^BlockMOHTTPRequestFail)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^BlockMOUploadImageHandler)(NSURLResponse *response, id responseObject, NSError *error);

/**
 *  缓存类型
 */
typedef enum {
    // 禁用缓存（默认）
    CacheTypeDisable,
    // 普通缓存类型（5分钟缓存有效期）
    CacheTypeNormal,
    // 持久化缓存（缓存不会过期）
    CacheTypePersistant
} CacheType;

@interface HttpService : NSObject

// 公共参数
@property (nonatomic, retain) NSDictionary *commonParameters;

@property (nonatomic, retain) AFHTTPRequestOperationManager *httpClient;

/**
 *  获取Http服务单例
 */
+ (instancetype)defaultService;

/**
 *  封装的GET请求
 *
 *  @param URLString          请求url地址（只有host和path，不带参数）
 *  @param parameters         请求参数
 *  @param responseModelClass 解析的JSONModel
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                      cacheType:(CacheType)cacheType
                 JSONModelClass:(Class)responseModelClass
                        success:(BlockMOHTTPRequestSuccess)success
                        failure:(BlockMOHTTPRequestFail)failure;

/**
 *  封装的POST请求
 *
 *  @param URLString          请求url地址（只有host和path，不带参数）
 *  @param parameters         请求参数
 *  @param success            成功回调
 *  @param failure            失败回调
 *
 *  @return 已发送的request 可以为nil
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  JSONModelClass:(Class)responseModelClass
                         success:(BlockMOHTTPRequestSuccess)success
                         failure:(BlockMOHTTPRequestFail)failure;

/**
 *  封装的图片上传请求
 *
 *  @param path             本地图片地址
 *  @param fileName         文件名
 *  @param handler          回调
 *
 *  @return 已发送的request 可以为nil
 */
- (NSURLSessionUploadTask *)uploadImageWithFilePath:(NSString *)path
                                       fileName:(NSString *)fileName
                                        handler:(BlockMOUploadImageHandler)handler;

@end
