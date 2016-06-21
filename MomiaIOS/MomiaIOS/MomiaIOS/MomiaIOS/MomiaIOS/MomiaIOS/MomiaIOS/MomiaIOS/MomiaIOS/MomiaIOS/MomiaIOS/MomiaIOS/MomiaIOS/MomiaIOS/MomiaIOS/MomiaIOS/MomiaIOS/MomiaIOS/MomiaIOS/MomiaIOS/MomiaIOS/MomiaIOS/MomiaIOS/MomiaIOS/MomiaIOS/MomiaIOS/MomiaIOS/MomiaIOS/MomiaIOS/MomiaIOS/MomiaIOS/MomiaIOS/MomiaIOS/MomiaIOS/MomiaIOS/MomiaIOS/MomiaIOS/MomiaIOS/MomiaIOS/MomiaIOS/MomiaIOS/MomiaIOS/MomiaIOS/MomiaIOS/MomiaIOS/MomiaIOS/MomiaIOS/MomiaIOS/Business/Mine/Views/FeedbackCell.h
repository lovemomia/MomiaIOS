//
//  FeedbackCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FeedbackCell : MOTableCell

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end
