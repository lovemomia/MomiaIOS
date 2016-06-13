//
//  NSURL+MOURL.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "NSURL+MOURL.h"
#import "NSString+MOURLEncode.h"

@implementation NSURL (MOURL)

- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *keyValuePairs = [self.query componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in keyValuePairs) {
        NSArray *element = [keyValuePair componentsSeparatedByString:@"="];
        
        if (element.count != 2) continue;
        
        NSString *key = element[0], *value = element[1];
        
        if (key.length == 0) continue;
        
        queryDict[[key URLDecodedString]] = [value URLDecodedString];
    }
    
    return [NSDictionary dictionaryWithDictionary:queryDict];
}

@end
