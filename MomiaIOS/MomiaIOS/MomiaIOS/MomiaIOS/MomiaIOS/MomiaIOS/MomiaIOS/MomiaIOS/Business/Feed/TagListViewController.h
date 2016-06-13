//
//  TagListViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/9.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "FeedTagListModel.h"

@protocol TagChooseDelegate <NSObject>

-(void)onTagChooseFinish:(FeedTag *)tag;
-(void)onCancel;

@end

@interface TagListViewController : MOGroupStyleTableViewController

@property (assign, nonatomic) id<TagChooseDelegate> delegate;

@end
