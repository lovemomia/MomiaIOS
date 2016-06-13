//
//  MJRefreshHelper.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MJRefreshHelper.h"

@implementation MJRefreshHelper

+ (MJRefreshGifHeader *)createGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
//    NSArray *refreshingImages = @[[UIImage imageNamed:@"IconLoading_1"], [UIImage imageNamed:@"IconLoading_2"], [UIImage imageNamed:@"IconLoading_3"], [UIImage imageNamed:@"IconLoading_4"], [UIImage imageNamed:@"IconLoading_5"], [UIImage imageNamed:@"IconLoading_6"], [UIImage imageNamed:@"IconLoading_7"]];
    NSArray *refreshingImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"IconLoading_1"], [UIImage imageNamed:@"IconLoading_2"], [UIImage imageNamed:@"IconLoading_3"], [UIImage imageNamed:@"IconLoading_4"], [UIImage imageNamed:@"IconLoading_5"], [UIImage imageNamed:@"IconLoading_6"], [UIImage imageNamed:@"IconLoading_7"], nil];
    [header setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    return header;
}

@end
