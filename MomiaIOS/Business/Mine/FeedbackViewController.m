//
//  FeedbackViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedbackViewController.h"

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
    
    
}

#pragma mark - keyboard event response
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    NSLog(@"keyboardWillShow");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    CGFloat topHeight = 20 + self.navigationController.navigationBar.frame.size.height;//状态栏和navigationbar高度
    CGFloat textHeight;
    if(self.editingType == EditingTypeTextField)
        textHeight = self.infoTextField.frame.origin.y + self.infoTextField.frame.size.height;
    else textHeight = self.contentTextView.frame.origin.y + self.contentTextView.frame.size.height;
    
    CGFloat bottomHeight = SCREEN_HEIGHT - topHeight - textHeight;
    
    CGFloat gap = bottomHeight - keyboardBounds.size.height;
    
    self.textGap = gap;
    
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





-(void) keyboardWillHide:(NSNotification *)note{

    NSLog(@"keyboardWillHide");
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


#pragma mark - viewController life cycle

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    [self.contentTextView setReturnKeyType:UIReturnKeyDone];
    [self.contentTextView setDelegate:self];
    [self.infoTextField setDelegate:self];
    [self.infoTextField setText:[[[AccountService defaultService] account] phone]];

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

#pragma mark - textView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");

    self.editingType = EditingTypeTextView;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"shouldChangeTextInRange");

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
}



@end
