//
//  Toast.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toast : NSObject

+ (void)make:(UIView *)view andShow:(NSString *)text;

@end
