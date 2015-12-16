//
//  FeedbackViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackCell.h"
#import "PostPersonModel.h"

static NSString * identifier = @"CellFeedbackIdentifier";

@interface FeedbackViewController ()

@property(nonatomic,weak) UIView * activeView;

@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * email;

@end

@implementation FeedbackViewController

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

-(void)onFinishClick {
    
    if(self.content.length == 0) {
        [AlertNotice showNotice:@"反馈意见不能为空"];
        return;
    }
    
    if(self.content.length >= 200) {
        [AlertNotice showNotice:@"反馈意见超过200字"];
    }
    
    if(self.email.length == 0) {
        [AlertNotice showNotice:@"联系方式不能为空"];
        return;
    }
    
    [self postFeedback];
    
}

-(void)postFeedback
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"content":self.content,@"contact":self.email};
    
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/feedback")
                           parameters:params
                       JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  [AlertNotice showNotice:@"感谢您的反馈"];
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];

}


#pragma mark - solve active textObject hidden by keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)removeForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect textRect = [self.view convertRect:self.activeView.bounds fromView:self.activeView];
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    UITableViewCell * cell;
    UIView *view = self.activeView;
    while (view != nil && ![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    cell = (UITableViewCell *)view;
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if (!CGRectContainsPoint(aRect, textRect.origin) ) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeView = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeView = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)editingChanged:(UITextField *)field
{
    self.email = field.text;
    NSLog(@"email:%@",self.email);
}

- (void)moTextViewDidBeginEditing:(UITextView *)textView
{
    self.activeView = textView;
}
- (void)moTextViewDidEndEditing:(UITextView *)textView
{
    self.activeView = nil;
}

-(void)moTextViewDidChange:(UITextView *)textView
{
    self.content = textView.text;
    NSLog(@"content:%@",self.content);
}


#pragma mark - tableView dataSource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackCell * cell = [FeedbackCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifier];
    cell.backgroundColor = tableView.backgroundColor;
    [cell.contentTextView addPlaceHolder:@"请输入您的反馈意见（200字以内）"];
    [cell.emailTextField setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    cell.contentTextView.placeHolderTextView.textColor = UIColorFromRGB(0x999999);
    cell.contentTextView.moDelegate = self;
    
       
    cell.emailTextField.delegate = self;
    [cell.emailTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedbackCell heightWithTableView:self.tableView withIdentifier:identifier forIndexPath:indexPath data:nil];
}

#pragma mark - viewController life cycle

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeForKeyboardNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishClick)];
    [FeedbackCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifier];
  
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

@end
