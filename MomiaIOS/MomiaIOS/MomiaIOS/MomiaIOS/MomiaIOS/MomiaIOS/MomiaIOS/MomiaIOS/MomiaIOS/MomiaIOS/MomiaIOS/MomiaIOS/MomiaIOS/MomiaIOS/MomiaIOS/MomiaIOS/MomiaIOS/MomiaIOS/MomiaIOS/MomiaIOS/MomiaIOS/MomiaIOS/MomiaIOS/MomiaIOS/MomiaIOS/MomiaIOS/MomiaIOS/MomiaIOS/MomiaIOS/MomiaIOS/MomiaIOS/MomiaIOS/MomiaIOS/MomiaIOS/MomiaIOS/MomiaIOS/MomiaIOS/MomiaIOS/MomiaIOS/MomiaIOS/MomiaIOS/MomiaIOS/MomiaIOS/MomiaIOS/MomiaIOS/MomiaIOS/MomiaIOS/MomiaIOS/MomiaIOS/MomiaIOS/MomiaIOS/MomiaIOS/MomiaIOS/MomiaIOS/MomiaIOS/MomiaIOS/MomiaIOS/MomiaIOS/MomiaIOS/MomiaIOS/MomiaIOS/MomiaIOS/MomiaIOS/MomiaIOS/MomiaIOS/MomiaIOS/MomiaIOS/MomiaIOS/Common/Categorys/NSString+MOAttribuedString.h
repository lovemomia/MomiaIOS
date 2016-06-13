//
//  NSString+MOAttribuedString.h
//  MomiaIOS
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MOAttribuedString)

-(NSAttributedString *)attributedStringWithColor:(UIColor *) color andFont:(UIFont *) font;

@end
