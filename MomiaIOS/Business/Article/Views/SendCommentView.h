//
//  SendCommentView.h
//  MomiaIOS
//
//  Created by Owen on 15/5/19.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendCommentBlock)(UIButton * sender,UITextField * textContentView);

@interface SendCommentView : UIView<UITextFieldDelegate>

-(void)set_sentCommentBlock:(SendCommentBlock)block;

@end
