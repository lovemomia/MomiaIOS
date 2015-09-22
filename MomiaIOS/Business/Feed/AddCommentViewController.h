//
//  AddCommentViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface AddCommentViewController : MOViewController<MOTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentLay;
@property (weak, nonatomic) IBOutlet UITextView *inputTv;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
