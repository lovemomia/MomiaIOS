//
//  FeedbackViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SubmitPostModel.h"

#define keyboardHeight 253

typedef enum {
    EditingTypeTextField,
    EditingTypeTextView
} EditingType ;

@interface FeedbackViewController ()

//@property(nonatomic,assign) CGFloat keyboardHeight;
@property(nonatomic,assign) CGFloat textGap;
@property(nonatomic,assign) EditingType editingType;

@end

@implementation FeedbackViewController


- (IBAction)onSubmitClick:(id)sender {
    if(self.contentTextView.text.length > 200) {
        [AlertNotice showNotice:@"反馈内容应在100字以内"];
    } else if(self.infoTextField.text.length > 100) {
        [AlertNotice showNotice:@"个人联系方式应在50字以内"];
    } else if([self.contentTextView.text isEqualToString:@""]) {
        [AlertNotice showNotice:@"反馈内容不能为空"];
    } else {
        //开始提交反馈
        NSDictionary * dic = @{@"content":self.contentTextView.text,
                               @"email":self.infoTextField.text};
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self.view setUserInteractionEnabled:NO];
        
        [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feedback") parameters:dic JSONModelClass:[SubmitPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];

            [self.view setUserInteractionEnabled:YES];
            [self.navigationController popViewControllerAnimated:YES];
            [AlertNotice showNotice:@"我们已收到您的反馈，谢谢"];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];

            [self.view setUserInteractionEnabled:YES];
            
            [AlertNotice showNotice:[error message]];
            
            NSLog(@"error:%@",[error domain]);
        }];

    }
}


-(void)moveView
{
    
    CGFloat topHeight = 20 + self.navigationController.navigationBar.frame.size.height;//状态栏和navigationbar高度
    CGFloat textHeight;
    if(self.editingType == EditingTypeTextField) {
        textHeight = self.infoTextField.frame.origin.y + self.infoTextField.frame.size.height;
    }
    else {
        textHeight = self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height;
    }
    
    CGFloat bottomHeight = SCREEN_HEIGHT - topHeight - textHeight;
    
    CGFloat gap = bottomHeight - keyboardHeight;
    
    self.textGap = gap;
    
    NSLog(@"Gpa:%f",self.textGap);
    
    if(gap < 0) {//表明键盘挡住了textField
        gap = fabs(gap);
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=gap;//view的Y轴上移
        frame.size.height +=gap; //View的高度增加
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];//设置调整界面的动画效果
        
    }

}


-(void)backView
{
    if (self.textGap < 0) {
        CGFloat gap = fabs(self.textGap);
        NSTimeInterval animationDuration = 0.30f;
        
        CGRect frame = self.view.frame;
        frame.origin.y += gap;
        frame.size. height -= gap;
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }

}

#pragma mark - keyboard event response
//Code from Brett Schumann
-(void) keyboardDidShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
}

-(void) keyboardDidHide:(NSNotification *)note{

  
}


#pragma mark - viewController life cycle

-(void)viewDidAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    [self.contentTextView setReturnKeyType:UIReturnKeyDone];
    [self.contentTextView addPlaceHolder:@"请输入您的意见(100字以内)"];
    self.contentTextView.moDelegate = self;
    [self.infoTextField setDelegate:self];
    [self.infoTextField setPlaceholder:@"联系方式(可选)"];
    [self.infoTextField setText:[[[AccountService defaultService] account] mobile]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - moTextView Delegate

-(void)moTextViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"moTextViewDidBeginEditing");
    
    self.editingType = EditingTypeTextView;
    [self moveView];
}



-(void)moTextViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"moTextViewDidEndEditing");

    [self backView];

}

#pragma mark - textField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    self.editingType = EditingTypeTextField;
    [self moveView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self backView];
}



@end
