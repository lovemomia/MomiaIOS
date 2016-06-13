//
//  TopicListViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"
#import "Course.h"

@protocol TopicChooseDelegate <NSObject>

-(void)onChooseFinish:(Course *)topic;
-(void)onCancel;

@end

@interface TopicListViewController : MOTableViewController

@property (assign, nonatomic) id<TopicChooseDelegate> delegate;

@end
