//
//  UIButton+Block.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton* btn);

@interface UIButton (Block)

- (void)addAction:(ButtonBlock)block;
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

@end
