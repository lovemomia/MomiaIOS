//
//  NSString+MOEncrypt.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "NSString+MOEncrypt.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MOEncrypt)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)(strlen(cStr)), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
