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
#import "ISDiskCache.h"
#import "CityManager.h"
#import "ServerErrorHandler.h"

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
        [ISDiskCache sharedCache].limitOfSize = 10 * 1024 * 1024; // 10MB
    }
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                      cacheType:(CacheType)cacheType
                 JSONModelClass:(Class)responseModelClass
                        success:(BlockMOHTTPRequestSuccess)success
                        failure:(BlockMOHTTPRequestFail)failure {
    
    NSMutableDictionary *allParams = [self createBasicParams];
    [allParams addEntriesFromDictionary:parameters];
    
    NSString *cacheUrl;
    if (cacheType == CacheTypeNormal) {
        // make cache url
        cacheUrl = [self appendUrl:URLString withParams:allParams];
    }
    
    BlockMOHTTPRequestSuccess onSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // cache
        if (cacheType == CacheTypeNormal) {
            [[ISDiskCache sharedCache] setObject:responseObject forKey:cacheUrl];
        }
        
        if (responseModelClass == nil) {
            success(operation, responseObject);
            return;
        }
        
        BaseModel *result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:responseObject error:nil];
        if (result == nil) {
            result = [[BaseModel alloc]initWithDictionary:responseObject error:nil];
        }
        if (result.errNo == 0) {
            success(operation, result);
            NSLog(@"http (GET) success: %@", responseObject);
            
        } else {
            NSError *err = [[NSError alloc]initWithCode:result.errNo message:result.errMsg];
            [[ServerErrorHandler defaultHandler] handlerError:err];
            failure(operation, err);
            
            NSLog(@"http (GET) fail: %@", responseObject);
        }

    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithCode:-1 message:@"网络异常，请稍后再试"];
        failure(operation, err);
        
        NSLog(@"http (GET) fail: %@", error);
    };
    
    if (cacheType == CacheTypeNormal) {
        // check cache first
        id cache = [[ISDiskCache sharedCache] objectForKey:cacheUrl];
        if (cache) {
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
                [[ISDiskCache sharedCache] removeObjectForKey:cacheUrl];
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
    BlockMOHTTPRequestSuccess onSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseModelClass == nil) {
            success(operation, responseObject);
            return;
        }
        
        BaseModel *result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:responseObject error:nil];
        if (result == nil) {
            result = [[BaseModel alloc]initWithDictionary:responseObject error:nil];
        }
        if (result.errNo == 0) {

            success(operation, result);
            NSLog(@"http (POST) success: %@", responseObject);
            
        } else {
            NSError *err = [[NSError alloc]initWithCode:result.errNo message:result.errMsg];
            [[ServerErrorHandler defaultHandler] handlerError:err];
            failure(operation, err);
            NSLog(@"http (POST) fail: %@", responseObject);
        }
    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithCode:-1 message:@"网络异常，请稍后再试"];
        failure(operation, err);
        
        NSLog(@"http (POST) fail: %@", error);
    };
    
    NSMutableDictionary *allParams = [self createBasicParams];
    [allParams addEntriesFromDictionary:parameters];
    
    AFHTTPRequestOperation *operation = [self.httpClient POST:URLString parameters:allParams success:onSuccess failure:onFail];
    return operation;
}

- (NSURLSessionUploadTask *)uploadImageWithFilePath:(NSString *)path
                                           fileName:(NSString *)fileName
                                            handler:(BlockMOUploadImageHandler)handler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://upload.momia.cn/upload/image" parameters:[self createBasicParams] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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

- (NSMutableDictionary *)createBasicParams {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
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
    [dic setObject:@"" forKey:@"device"];
    
    // 渠道号
    [dic setObject:@"appstore" forKey:@"channel"];
    
    // 网络类型
    [dic setObject:[Environment singleton].networkType forKey:@"net"];
    
    // cityid
    [dic setObject:[NSString stringWithFormat:@"%@", [CityManager shareManager].choosedCity.ids] forKey:@"city"];


    return dic;
}

- (NSString *)appendUrl:(NSString *)url withParams:(NSDictionary *)parameters {
    NSMutableString * ms = [[NSMutableString alloc]initWithString:url];
    if (![url containsString:@"?"]) {
        [ms appendString:@"?"];
    }
    for (NSString *key in [parameters keyEnumerator]) {
        NSString *value = [parameters valueForKey:key];
        [ms appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    return ms;
}

@end
