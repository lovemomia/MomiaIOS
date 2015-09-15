//
//  ConfigService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ConfigService.h"
#import "ConfigModel.h"

#define ANY           @"*"

@interface ConfigService()

@property (nonatomic, strong) NSDictionary *root;
@property (nonatomic, strong) NSDictionary *listenerDic;

@end

@implementation ConfigService

+ (instancetype)defaultService {
    static ConfigService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

- (NSDictionary *)listenerDic {
    if (!_listenerDic) {
        _listenerDic = [[NSMutableDictionary alloc]init];
    }
    return _listenerDic;
}

- (void)refresh {
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/config") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ConfigModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ConfigModel *model = responseObject;
        [self setConfig:model.data];
        
        NSLog(@"config refresh success : %@", model.data);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"config refresh failed");
    }];
}

- (void)setConfig:(NSDictionary *)config {
    if (!config) {
        return;
    }
    
    if (![self write:config]) {
        NSLog(@"fail to write config");
        return;
    }
    
    NSDictionary *old = self.root;
    self.root = config;
    
    NSArray *list = [self.listenerDic objectForKey:ANY];
    if (list) {
        for (id<ConfigChangeListener> l in list) {
            [l onConfigChange:ANY from:old to:config];
        }
    }
    
    for (NSString *key in self.listenerDic) {
        if ([ANY isEqualToString:key]) {
            continue;
        }
        NSObject *v1 = [old objectForKey:key];
        NSObject *v2 = [config objectForKey:key];
        BOOL eq = (v1 == nil) ? (v2 == nil) : [v1 isEqual:v2];
        if (eq) {
            continue;
        }
        
        list = [self.listenerDic objectForKey:key];
        NSLog(@"config changed");
        for (id<ConfigChangeListener> l in list) {
            [l onConfigChange:key from:v1 to:v2];
        }
    }
}

- (BOOL)getBoolean:(NSString *)key defaultValue:(BOOL)def {
    NSNumber *value = [[self root] objectForKey:key];
    if (value == nil) {
        return def;
    }
    return [value boolValue];
}

- (NSInteger)getInteger:(NSString *)key defaultValue:(NSInteger)def {
    NSNumber *value = [[self root] objectForKey:key];
    if (value == nil) {
        return def;
    }
    return [value integerValue];
}

- (CGFloat)getFloat:(NSString *)key defaultValue:(CGFloat)def {
    NSNumber *value = [[self root] objectForKey:key];
    if (value == nil) {
        return def;
    }
    return [value floatValue];
}

- (NSString *)getString:(NSString *)key defaultValue:(NSString *)def {
    NSString *value = [[self root] objectForKey:key];
    if (value == nil) {
        return def;
    }
    return value;
}

- (NSDictionary *)getDictionary:(NSString *)key {
    return [[self root] objectForKey:key];
}

- (void)addListener:(id<ConfigChangeListener>)listener forKey:(NSString *)key {
    NSMutableArray *list = [self.listenerDic objectForKey:key];
    if (list == nil) {
        list = [NSMutableArray new];
        [self.listenerDic setValue:list forKey:key];
    }
    if (![list containsObject:listener]) {
        [list addObject:listener];
    }
}

- (void)removeListener:(id<ConfigChangeListener>)listener forKey:(NSString *)key {
    NSMutableArray *list = [self.listenerDic objectForKey:key];
    if (list) {
        [list removeObject:listener];
        if ([list count] == 0) {
            [self.listenerDic setValue:nil forKey:key];
        }
    }
}

- (NSDictionary *)root {
    if (!_root) {
        NSDictionary *dump = [self read];
        if (dump == nil) {
            dump = [NSDictionary new];
            _root = dump;
        }
    }
    return _root;
}

- (NSDictionary *)read {
    NSDictionary *config;
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"config"];
    if (myEncodedObject == nil) {
        return nil;
    }
    config = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return config;
}

- (BOOL)write:(NSDictionary *)config {
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:config];
    if (archiveData == nil) {
        return NO;
    }
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setObject:archiveData forKey:@"config"];
    return YES;
}

@end
