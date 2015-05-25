//
//  SendCommentView.m
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SendCommentView.h"

@interface SendCommentView()

@property(nonatomic,strong) UITextField * textField;
@property(nonatomic,strong) UIButton * sendBtn;
@property(nonatomic,strong) SendCommentBlock sendCommentBlock;//注意arc下，对于block，strong等于copy

@end

@implementation SendCommentView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        _textField = [[UITextField alloc] init];
        _sendBtn = [[UIButton alloc] init];
        [self addSubview:_textField];
        [self addSubview:_sendBtn];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.right.equalTo(_sendBtn.mas_left).with.offset(-10);
        }];
        
        
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(8);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.width.equalTo(@50);
        }];
        
        //defaultSetting
        [self defaultSetting];
        
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
    
}

-(void)set_sentCommentBlock:(SendCommentBlock)block
{
    self.sendCommentBlock = block;
}


-(IBAction)sendBtnClick:(id)sender
{
    self.sendCommentBlock(sender,self.textField);
}


-(void)defaultSetting
{
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.textField setPlaceholder:@"说点什么吧。。。"];
    [self.textField setReturnKeyType:UIReturnKeyDone];
    [self.textField setDelegate:self];
    [self.textField setTextColor:[UIColor blackColor]];
    [self.textField setFont:[UIFont systemFontOfSize:15.0f]];
    [self.textField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont systemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
    [self.textField setClearsOnBeginEditing:YES];
    [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([self superview].mas_bottom).with.offset(-keyboardBounds.size.height);
    }];
    
    // commit animations
    [UIView commitAnimations];
}



-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([self superview].mas_bottom).with.offset(0);
    }];
    
    // commit animations
    [UIView commitAnimations];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end

