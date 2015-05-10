//
//  HttpService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HttpService.h"
#import "AFHTTPRequestOperation.h"
#import "BaseModel.h"

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
        id result = [(BaseModel *)[responseModelClass alloc]initWithDictionary:responseObject error:nil];
        success(operation, result);
    };
    
    BlockMOHTTPRequestFail onFail = ^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    };
    
    AFHTTPRequestOperation *operation = [self.httpClient GET:URLString parameters:parameters success:onSuccess failure:onFail];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  JSONModelClass:(Class)responseModelClass
                         success:(BlockMOHTTPRequestSuccess)success
                         failure:(BlockMOHTTPRequestFail)failure {
    AFHTTPRequestOperation *operation = [self.httpClient POST:URLString parameters:parameters success:success failure:failure];
    return operation;
}

@end
