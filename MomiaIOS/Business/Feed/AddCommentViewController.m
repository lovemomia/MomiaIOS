//
//  AddCommentViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "AddCommentViewController.h"

#define MAX_LIMIT_NUMS     100 //最大输入只能100个字符

@interface AddCommentViewController ()
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) UITextView *inputTv;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation AddCommentViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"添加评论";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishClick)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"TitleCancel"]];
    
    UITextView *input = [[UITextView alloc]init];
    input.font = [UIFont systemFontOfSize:14];
    [input addPlaceHolder:@"输入您的评论，限100字以内"];
    self.inputTv = input;
    [self.view addSubview:input];
    
    UILabel *num = [[UILabel alloc]init];
    num.font = [UIFont systemFontOfSize:13];
    num.textColor = UIColorFromRGB(0x999999);
    num.textAlignment = UITextAlignmentRight;
    self.numLabel = num;
    [self.view addSubview:num];
    
    [input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@22);
        make.right.equalTo(self.view).with.offset(-5);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    
    self.numLabel.text = @"100/100";
    self.inputTv.moDelegate = self;
    
    [self performSelector:@selector(openKeyboard) withObject:nil afterDelay:0.2f];
}

- (void)openKeyboard {
    [self.inputTv becomeFirstResponder];
}

- (void)onCancelClicked {
    self.cancelBlock();
}

- (void)onFinishClick {
    if (self.inputTv.text.length == 0) {
        [Toast make:self.view andShow:@"请输入评论内容~"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"id":self.ids, @"content":self.inputTv.text};
    [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feed/comment/add") parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.successBlock();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDialogWithTitle:nil message:error.message];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    [self.inputTv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-keyboardBounds.size.height);
    }];
    [self.inputTv layoutIfNeeded];
    
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-keyboardBounds.size.height);
    }];
    [self.numLabel layoutIfNeeded];
    
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    [self.inputTv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [self.inputTv layoutIfNeeded];
    
    // commit animations
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MOTextViewDelegate

- (void)moTextViewDidBeginEditing:(UITextView *)textView {
//    CGRect frame = self.contentLay.frame;
//    
//    //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
//    int offset = (frame.origin.y+62)-(self.view.frame.size.height-216.0);//键盘高度216
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:0.30f];//动画持续时间
//    
//    if (offset>0) {
//        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//        self.contentLay.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
}
- (void)moTextViewDidEndEditing:(UITextView *)textView {
}

- (BOOL)moTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }
    else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)moTextViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

@end
