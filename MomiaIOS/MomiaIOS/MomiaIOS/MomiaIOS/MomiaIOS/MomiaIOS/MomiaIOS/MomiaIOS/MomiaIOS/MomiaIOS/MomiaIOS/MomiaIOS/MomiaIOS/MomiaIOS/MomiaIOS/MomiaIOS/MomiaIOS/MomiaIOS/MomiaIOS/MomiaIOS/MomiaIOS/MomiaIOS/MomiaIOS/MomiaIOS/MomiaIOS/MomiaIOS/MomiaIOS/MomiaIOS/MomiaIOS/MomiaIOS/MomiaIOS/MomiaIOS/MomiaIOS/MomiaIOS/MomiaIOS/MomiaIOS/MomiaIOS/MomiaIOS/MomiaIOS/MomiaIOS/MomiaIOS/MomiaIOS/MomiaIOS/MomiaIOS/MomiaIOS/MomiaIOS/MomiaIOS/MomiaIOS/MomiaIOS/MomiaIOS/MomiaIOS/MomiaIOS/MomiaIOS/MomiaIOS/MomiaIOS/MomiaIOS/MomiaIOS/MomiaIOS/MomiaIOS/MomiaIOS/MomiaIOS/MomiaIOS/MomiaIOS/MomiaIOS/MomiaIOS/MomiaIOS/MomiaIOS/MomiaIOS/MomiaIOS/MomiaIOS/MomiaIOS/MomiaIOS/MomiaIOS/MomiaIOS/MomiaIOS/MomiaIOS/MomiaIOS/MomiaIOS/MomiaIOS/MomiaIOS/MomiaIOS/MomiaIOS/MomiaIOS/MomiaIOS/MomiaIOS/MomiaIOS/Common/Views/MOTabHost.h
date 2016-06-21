//
//  MOTabHost.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnItemClickedListener)(NSInteger index);

@interface MOTabHost : UIView

@property (nonatomic , strong) OnItemClickedListener onItemClickedListener;

- (instancetype)initWithItems:(NSArray *)items;

- (void)setItemSelect:(NSInteger)index;

@end
