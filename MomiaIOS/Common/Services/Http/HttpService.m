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
    }
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                      cacheType:(CacheType)cacheType
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
            
        } else {
            NSError *err = [[NSError alloc]initWithDomain:result.errMsg code:result.errNo userInfo:nil];
            failure(operation, err);
        }
        
        NSLog(@"http (GET) success: %@", responseObject);
    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithDomain:@"网络异常，请稍后再试" code:-1 userInfo:nil];
        failure(operation, err);
        
        NSLog(@"http (GET) fail: %@", error);
    };
    
    AFHTTPRequestOperation *operation = [self.httpClient GET:URLString parameters:parameters success:onSuccess failure:onFail];
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
            
        } else {
            NSError *err = [[NSError alloc]initWithDomain:result.errMsg code:result.errNo userInfo:nil];
            failure(operation, err);
        }
        
//        NSLog(@"http (POST) success: %@", responseObject);
    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [[NSError alloc]initWithDomain:@"网络异常，请稍后再试" code:-1 userInfo:nil];
        failure(operation, err);
        
        NSLog(@"http (POST) fail: %@", error);
    };
    
    AFHTTPRequestOperation *operation = [self.httpClient POST:URLString parameters:parameters success:onSuccess failure:onFail];
    return operation;
}

- (NSURLSessionUploadTask *)uploadImageWithFilePath:(NSString *)path
                                           fileName:(NSString *)fileName
                                            handler:(BlockMOUploadImageHandler)handler {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://i.momia.cn/upload/image" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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

@end
