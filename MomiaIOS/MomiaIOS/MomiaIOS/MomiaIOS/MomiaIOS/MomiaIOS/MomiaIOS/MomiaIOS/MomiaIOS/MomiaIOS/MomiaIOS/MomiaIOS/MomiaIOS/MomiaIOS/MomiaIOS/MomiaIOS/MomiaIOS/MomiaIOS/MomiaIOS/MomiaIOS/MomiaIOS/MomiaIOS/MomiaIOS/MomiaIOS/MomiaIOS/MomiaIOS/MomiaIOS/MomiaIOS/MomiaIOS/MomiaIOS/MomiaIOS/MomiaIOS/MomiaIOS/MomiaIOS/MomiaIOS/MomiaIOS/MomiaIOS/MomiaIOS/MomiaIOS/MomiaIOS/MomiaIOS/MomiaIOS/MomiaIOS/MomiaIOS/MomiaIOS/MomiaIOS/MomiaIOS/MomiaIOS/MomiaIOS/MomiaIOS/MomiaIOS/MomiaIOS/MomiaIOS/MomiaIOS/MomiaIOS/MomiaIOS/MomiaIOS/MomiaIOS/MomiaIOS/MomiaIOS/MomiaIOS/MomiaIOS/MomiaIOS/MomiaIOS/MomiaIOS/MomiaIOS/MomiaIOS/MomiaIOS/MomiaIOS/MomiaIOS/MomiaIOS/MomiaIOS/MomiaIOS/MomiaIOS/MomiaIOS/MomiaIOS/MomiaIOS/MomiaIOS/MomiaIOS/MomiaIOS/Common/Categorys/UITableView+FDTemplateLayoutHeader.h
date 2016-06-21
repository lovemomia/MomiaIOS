//
//  UITableView+FDTemplateLayoutHeader.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (FDTemplateLayoutHeader)

- (CGFloat)fd_heightForHeaderViewWithIdentifier:(NSString *)identifier configuration:(void (^)(id headerView))configuration;

@end
