//
//  BookSkuListViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "CourseSkuListModel.h"

@protocol OnSkuSelectDelegate <NSObject>

- (void)onSkuSelect:(CourseSku *)sku inController:(id)controller;

@end

@interface BookSkuListViewController : MOGroupStyleTableViewController

@property (nonatomic, assign) id<OnSkuSelectDelegate> delegate;

- (void)clearChooseStatus;

@end
