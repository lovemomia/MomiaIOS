//
//  TopicListViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"
#import "TopicListModel.h"

@protocol TopicChooseDelegate <NSObject>

-(void)onChooseFinish:(Topic *)topic;
-(void)onCancel;

@end

@interface TopicListViewController : MOTableViewController

@property (assign, nonatomic) id<TopicChooseDelegate> delegate;

@end
