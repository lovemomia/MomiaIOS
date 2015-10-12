//
//  HttpService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HttpService.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLSessionManager.h"
#import "BaseModel.h"
#import "UploadImageModel.h"
#import "CityManager.h"
#import "ServerErrorHandler.h"
#import "NSString+MOEncrypt.h"
#import "DateManager.h"

@implementation HttpService

+ (instancetype)defaultService {
    static HttpService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

- (instancetype)init {
    if (self = [super init]) {
        self.httpClient = [AFHTTPRequestOperationManager manager];
        
        self.httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.httpClient.requestSerializer setValue:@"API1.0(com.youxing.DuoLa;iOS)" forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                      cacheType:(CacheType)cacheType
                 JSONModelClass:(Class)responseModelClass
                        success:(BlockMOHTTPRequestSuccess)success
                        failure:(BlockMOHTTPRequestFail)failure {
    // 构建基本参数
    NSMutableDictionary *allParams = [self basicParamsWithParams:parameters];
    
    NSString *cacheUrl;
    if (cacheType == CacheTypeNormal) {
        // make cache url
        cacheUrl = [self appendUrl:URLString withParams:allParams];
    }
    
    BlockMOHTTPRequestSuccess onSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // cache
        if (cacheType != CacheTypeDisable) {
            [[CacheService defaultService] removeObjectForKey:cacheUrl];
            [[CacheService defaultService] setObject:responseObject forKey:cacheUrl];
        }
        
        if (responseModelClass == nil) {
            success(operation, responseObject);
            return;
        }
        
        BaseModel *result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:responseObject error:nil];
        if (result == nil) {
            result = [[BaseModel alloc]initWithDictionary:responseObject error:nil];
        }
        if ([result isKindOfClass:responseModelClass] && result.errNo == 0) {
            success(operation, result);
            NSLog(@"http (GET) success: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, responseObject);
            
            // 校准时间
            [DateManager shareManager].serverTimeSeconds = (long)(result.timestamp / 1000);
            
        } else {
            NSError *err;
            if (result.errNo == 0) {
                err = [[NSError alloc]initWithCode:result.errNo message:@"数据解析失败"];
            } else {
                err = [[NSError alloc]initWithCode:result.errNo message:result.errMsg];
            }
            [[ServerErrorHandler defaultHandler] handlerError:err];
            failure(operation, err);
            
            NSLog(@"http (GET) fail: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, responseObject);
        }

    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithCode:-1 message:@"网络异常，请稍后再试"];
        failure(operation, err);
        
        NSLog(@"http (GET) fail: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, error);
    };
    
    if (cacheType != CacheTypeDisable) {
        // check cache first
        id cache = [[CacheService defaultService] objectForKey:cacheUrl];
        if (cache) {
            while (1) {
                // check expire
                long now = [[[NSDate alloc]init] timeIntervalSince1970];
                long dt = now - [[CacheService defaultService] timeForKey:cacheUrl];
                
                if (cacheType == CacheTypeNormal && dt > 5 * 60) {
                    // 5 min cache expire
                    break;
                }
                
                BaseModel *result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:cache error:nil];
                if (result == nil) {
                    result = [[BaseModel alloc]initWithDictionary:cache error:nil];
                }
                if (result.errNo == 0) {
                    success(nil, result);
                    NSLog(@"http (Cache) success: %@", cache);
                    return nil;
                    
                } else {
                    NSLog(@"http (Cache) fail: %@", cache);
                    // clear cache
                    [[CacheService defaultService] removeObjectForKey:cacheUrl];
                }
                
                break;
            }
        }
    }
    
    AFHTTPRequestOperation *operation = [self.httpClient GET:URLString parameters:allParams success:onSuccess failure:onFail];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  JSONModelClass:(Class)responseModelClass
                         success:(BlockMOHTTPRequestSuccess)success
                         failure:(BlockMOHTTPRequestFail)failure {
    // 构建基本参数
    NSMutableDictionary *allParams = [self basicParamsWithParams:parameters];
    
    BlockMOHTTPRequestSuccess onSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseModelClass == nil) {
            success(operation, responseObject);
            return;
        }
        
        JSONModelError* error = nil;
        BaseModel *result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:responseObject error:&error];
        if (result == nil) {
            result = [[BaseModel alloc]initWithDictionary:responseObject error:nil];
        }
        if ([result isKindOfClass:responseModelClass] && result.errNo == 0) {

            success(operation, result);
            NSLog(@"http (POST) success: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, responseObject);
            
            // 校准时间
            [DateManager shareManager].serverTimeSeconds = (long)(result.timestamp / 1000);
            
        } else {
            NSError *err;
            if (result.errNo == 0) {
                err = [[NSError alloc]initWithCode:result.errNo message:@"数据解析失败"];
            } else {
                err = [[NSError alloc]initWithCode:result.errNo message:result.errMsg];
            }
            
            [[ServerErrorHandler defaultHandler] handlerError:err];
            failure(operation, err);
            NSLog(@"http (POST) fail: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, result);
        }
    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithCode:-1 message:@"网络异常，请稍后再试"];
        failure(operation, err);
        
        NSLog(@"http (POST) fail: \nurl : %@\nparams : %@\nresult : %@", URLString, allParams, error);
    };
    
//    AFHTTPRequestOperation *operation = [self.httpClient POST:URLString parameters:allParams success:onSuccess failure:onFail];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:allParams error:nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:onSuccess failure:onFail];
    [manager.operationQueue addOperation:operation];
    
    return operation;
}

- (NSURLSessionUploadTask *)uploadImageWithFilePath:(NSString *)path
                                           fileName:(NSString *)fileName
                                            handler:(BlockMOUploadImageHandler)handler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", MO_IMAGE_API_DOMAIN, @"/upload/image"] parameters:[self basicParamsWithParams:nil] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:fileName mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    BlockMOUploadImageHandler blockHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            handler(response, responseObject, error);
            NSLog(@"http (Upload Image) fail: %@", error);
            
        } else {
            id result = [[UploadImageModel alloc]initWithDictionary:responseObject error:nil];
            handler(response, result, error);
            
            NSLog(@"http (Upload Image) success: %@", responseObject);
        }
    };
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:blockHandler];
    
    [uploadTask resume];
    return uploadTask;
}

- (NSMutableDictionary *)basicParamsWithParams:(NSDictionary *)params {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (params) {
        [dic addEntriesFromDictionary:params];
    }
    
    // 用户token
    if ([[AccountService defaultService] isLogin]) {
        [dic setObject:[AccountService defaultService].account.token forKey:@"utoken"];
    }
    
    // app版本
    [dic setObject:MO_APP_VERSION forKey:@"v"];
    
    // 终端类型
    [dic setObject:@"iphone" forKey:@"terminal"];
    
    // 系统版本号
    [dic setObject:[NSString stringWithFormat:@"%f", MO_OS_VERSION] forKey:@"os"];
    
    // 设备型号，iphone6
    [dic setObject:[UIDevice currentDevice].model forKey:@"device"];
    
    // 渠道号
    [dic setObject:@"appstore" forKey:@"channel"];
    
    // 网络类型
    [dic setObject:[Environment singleton].networkType forKey:@"net"];
    
    // cityid
    [dic setObject:[NSString stringWithFormat:@"%@", [CityManager shareManager].choosedCity.ids] forKey:@"city"];

    
    // 签名
    NSString *sysSign = [self doSignWithParameters:dic];
    if (sysSign != nil) {
        [dic setObject:sysSign forKey:@"sign"];
    }
    
    if ([[LocationService defaultService] hasLocation]) {
        CLLocation *location = [LocationService defaultService].location;
        [self.httpClient.requestSerializer setValue:[NSString stringWithFormat:@"%f,%f", location.coordinate.longitude, location.coordinate.latitude] forHTTPHeaderField:@"User-Location"];
    }

    return dic;
}

- (NSString *)appendUrl:(NSString *)url withParams:(NSDictionary *)parameters {
    NSMutableString * ms = [[NSMutableString alloc]initWithString:url];

    NSRange range = [url rangeOfString:@"?"];
    if(range.length > 0) {
        [ms appendString:@"?"];
    }
    for (NSString *key in [parameters keyEnumerator]) {
        NSString *value = [parameters valueForKey:key];
        [ms appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    return ms;
}

#pragma mark -
#pragma mark URL签名

/**
 *  URL签名
 *
 *  @param dictionary 参数字典
 *
 *  @return 请求的sign字段
 */
- (NSString *)doSignWithParameters:(NSDictionary *)dictionary {
    
    // 签名
    if ([dictionary isKindOfClass:[NSDictionary class]] &&
        [dictionary count] > 0) {
        
        NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:[dictionary allKeys]];
        [allKeys sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString *sysSign = [[NSMutableString alloc] initWithCapacity:50];
        [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSObject *value = [dictionary objectForKey:obj];
            if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length == 0) {
                // do nothing;
            } else {
                [sysSign appendString:[NSString stringWithFormat:@"%@=%@", obj, [dictionary objectForKey:obj]]];
            }
        }];
        
        // 固定字符加密
        [sysSign appendString:@"key=578890d82212ae548d883bc7a201cdf4"];
        
        if ([sysSign length] > 0) {
            NSString *md5 = [sysSign md5];
            if (md5 != nil) {
                return md5;
            }
        }
    }
    
    return nil;
}

@end
