//
//  AccountService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService
@synthesize account = _account;


+ (instancetype)defaultService {
    static AccountService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

- (BOOL)isLogin {
    return self.account == nil ? NO : YES;
}

- (Account *)account {
    if (_account == nil) {
        Account *ac =[[Account alloc]init];
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        if (myEncodedObject == nil) {
            return nil;
        }
        
        ac = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        _account = ac;
    }
    return _account;
}

- (void)setAccount:(Account *)account {
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:account];
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setObject:archiveData forKey:@"account"];
    
    _account = account;
}

@end
