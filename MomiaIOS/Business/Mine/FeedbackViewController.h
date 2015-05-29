//
//  FeedbackViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface FeedbackViewController : MOViewController<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@end
