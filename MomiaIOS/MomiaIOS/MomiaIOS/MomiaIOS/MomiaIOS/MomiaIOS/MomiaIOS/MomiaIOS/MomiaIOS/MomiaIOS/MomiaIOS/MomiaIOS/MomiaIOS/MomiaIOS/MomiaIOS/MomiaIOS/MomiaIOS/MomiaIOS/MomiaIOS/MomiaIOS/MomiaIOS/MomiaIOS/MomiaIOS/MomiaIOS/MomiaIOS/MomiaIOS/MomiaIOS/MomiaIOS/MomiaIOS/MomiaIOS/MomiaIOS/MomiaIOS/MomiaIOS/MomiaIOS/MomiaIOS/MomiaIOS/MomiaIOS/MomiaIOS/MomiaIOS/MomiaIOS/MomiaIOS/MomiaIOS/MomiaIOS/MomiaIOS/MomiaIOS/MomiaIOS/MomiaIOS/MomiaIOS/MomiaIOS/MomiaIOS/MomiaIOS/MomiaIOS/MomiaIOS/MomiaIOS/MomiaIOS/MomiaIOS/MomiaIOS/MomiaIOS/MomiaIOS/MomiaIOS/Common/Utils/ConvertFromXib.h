//
//  ConvertFromXib.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertFromXib : NSObject

+(id)convertObjectWithNibNamed:(NSString *) nibName withClassNamed:(NSString *) className;

+(id)convertObjectWithNibNamed:(NSString *) nibName withIndex:(NSInteger)index;

@end
