//
//  AddCommentViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

typedef void (^BlockSuccess)();
typedef void (^BlockCancel)();

@interface AddCommentViewController : MOViewController<MOTextViewDelegate>

@property (nonatomic, strong) BlockSuccess successBlock;
@property (nonatomic, strong) BlockCancel cancelBlock;

@end
