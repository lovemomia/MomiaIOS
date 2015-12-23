//
//  ServerErrorHandler.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ServerErrorHandler.h"
#import "AppDelegate.h"

@interface ServerErrorHandler()<UIAlertViewDelegate>

@end

@implementation ServerErrorHandler

+ (instancetype)defaultHandler {
    static ServerErrorHandler *__handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __handler = [[self alloc] init];
    });
    return __handler;
}

- (BOOL)handlerError:(NSError *)error {
    if (error.code == 100001) {
        [self showDialogWithMessage:error.message withTag:error.code];
        return YES;
    }
    return NO;
}

- (void)showDialogWithMessage:(NSString *)message withTag:(NSInteger)tag {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alter.tag = tag;
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100001) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[AccountService defaultService] logout:app.root];
        [[AccountService defaultService] login:app.root success:nil];
    }
}

@end
