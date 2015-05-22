//
//  SuggestTagsViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"

@protocol SuggestTagsChooseDelegate <NSObject>

-(void)onChooseFinishWithAssorts:(NSArray *)assorts andCrowds:(NSArray *)crowds;
-(void)onCancel;

@end


@interface SuggestTagsViewController : MOTableViewController

@property (strong, nonatomic) NSArray *assorts;
@property (strong, nonatomic) NSArray *crowds;

@property (assign, nonatomic) id<SuggestTagsChooseDelegate> delegate;

@end
