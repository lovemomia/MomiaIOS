//
//  FeedbackViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "UITextView+Placeholder.h"

@interface FeedbackViewController : MOViewController<UITextFieldDelegate,MOTextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@end
