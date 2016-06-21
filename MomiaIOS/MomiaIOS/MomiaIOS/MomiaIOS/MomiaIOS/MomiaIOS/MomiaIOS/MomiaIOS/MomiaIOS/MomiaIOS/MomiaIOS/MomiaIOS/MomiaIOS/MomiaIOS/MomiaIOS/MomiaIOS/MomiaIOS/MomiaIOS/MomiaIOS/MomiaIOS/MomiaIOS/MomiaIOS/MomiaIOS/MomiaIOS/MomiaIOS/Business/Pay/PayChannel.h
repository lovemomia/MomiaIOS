//
//  PayChannel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayChannel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString *icon;

-(instancetype)initWithType:(NSInteger)type title:(NSString *)title desc:(NSString *)desc icon:(NSString *)icon select:(BOOL)select;

@end
