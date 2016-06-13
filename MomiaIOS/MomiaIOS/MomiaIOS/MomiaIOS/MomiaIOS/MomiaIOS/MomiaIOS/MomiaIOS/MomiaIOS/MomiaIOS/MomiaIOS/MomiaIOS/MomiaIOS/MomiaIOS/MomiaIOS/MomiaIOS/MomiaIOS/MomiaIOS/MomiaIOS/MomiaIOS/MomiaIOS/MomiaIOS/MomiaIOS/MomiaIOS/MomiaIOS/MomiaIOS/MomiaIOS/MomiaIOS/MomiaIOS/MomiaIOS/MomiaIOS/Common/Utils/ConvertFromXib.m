//
//  ConvertFromXib.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ConvertFromXib.h"

@implementation ConvertFromXib

+(id)convertObjectWithNibNamed:(NSString *) nibName withClassNamed:(NSString *) className{
    id neededObject;
    NSArray * bundleArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    for(id object in bundleArray) {
        if([object isKindOfClass:NSClassFromString(className)]) {
            neededObject = object;
        }
    }
    return neededObject;
}

+(id)convertObjectWithNibNamed:(NSString *) nibName withIndex:(NSInteger)index{
    id neededObject;
    NSArray * bundleArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    if(index < bundleArray.count) {
        neededObject = bundleArray[index];
    }
    return neededObject;
}


@end
