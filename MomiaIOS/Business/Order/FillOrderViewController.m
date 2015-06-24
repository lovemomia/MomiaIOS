//
//  FillOrderViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderViewController.h"
#import "FillOrderFooterView.h"

static NSString * identifier = @"FillOrderHeaderViewIdentifier";
static NSString * fillOrderItemIdentifier = @"CellFillOrderItem";
static NSString * fillOrderPersonIdentifier = @"CellFillOrderPerson";
static NSString * fillOrderRemarkIdentifier = @"CellFillOrderRemark";

@interface FillOrderViewController ()

@property(nonatomic, strong) NSArray * dataArray;
@property(nonatomic, strong) NSArray * HeaderArray;
@property(nonatomic, weak) UIView * activeView;


@end

@implementation FillOrderViewController

- (IBAction)onSureClick:(id)sender {
    
    NSURL * url = [NSURL URLWithString:@"tq://cashpay"];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - tableView dataSource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    header.textLabel.text = [self.HeaderArray[section] objectForKey:@"title"];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2) {
        return 35.0f;
    }
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view;
    if(section == 2) {
        view = [FillOrderFooterView cellWithTableView:tableView];
    }
    return view;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    switch (section) {
        case 0:
        {
           
        }
            break;
        case 1:
        {
           
        }
            break;
        default:
        {
          
        }
            break;
    }
    return cell;
    
    
}

/*

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

- (void)moTextViewDidBeginEditing:(UITextView *)textView
{
    self.activeView = textView;
}
- (void)moTextViewDidEndEditing:(UITextView *)textView
{
    self.activeView = nil;
}
*/

#pragma mark - view life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"提交订单";
  
    [FillOrderFooterView registerCellWithTableView:self.tableView];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:identifier];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
