//
//  FillOrderViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderViewController.h"
#import "FillOrderItemCell.h"
#import "FillOrderPersonCell.h"
#import "FillOrderPersonSelectedCell.h"
#import "FillOrderRemarkCell.h"
#import "FillOrderFooterView.h"

static NSString * identifier = @"FillOrderHeaderViewIdentifier";

@interface FillOrderViewController ()

@property(nonatomic, strong) NSArray * dataArray;
@property(nonatomic, strong) NSArray * HeaderArray;
@property(nonatomic, weak) UIView * activeView;


@end

@implementation FillOrderViewController


#pragma mark - tableView dataSource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
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
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            return [FillOrderPersonCell heightWithTableView:tableView forIndexPath:indexPath data:@{@"title":@"请选择1个成人和1个儿童"}];
        }
            break;
        case 1:
        {
            return [FillOrderItemCell heightWithTableView:tableView forIndexPath:indexPath data:self.dataArray[row]];
        }
            break;
        default:
        {
            return [FillOrderRemarkCell height];
        }
            break;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    switch (section) {
        case 0:
        {
            FillOrderPersonCell * person = [FillOrderPersonCell cellWithTableView:tableView forIndexPath:indexPath];
            person.data = @{@"title":@"请选择1个成人和1个儿童"};
            cell = person;
        }
            break;
        case 1:
        {
            FillOrderItemCell * item = [FillOrderItemCell cellWithTableView:tableView forIndexPath:indexPath];
            item.contentTextField.delegate = self;
            item.data = self.dataArray[row];
            cell = item;
        }
            break;
        default:
        {
            FillOrderRemarkCell * remark = [FillOrderRemarkCell cellWithTableView:tableView forIndexPath:indexPath];
            remark.placeHolder = @"请告诉我们您的特殊需求";
            remark.remarkTextView.moDelegate = self;
            cell = remark;
        }
            break;
    }
    return cell;
    
    
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

- (void)moTextViewDidBeginEditing:(UITextView *)textView
{
    self.activeView = textView;
}
- (void)moTextViewDidEndEditing:(UITextView *)textView
{
    self.activeView = nil;
}


#pragma mark - view life cycle

-(void)viewDidAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self removeForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"填写订单";
    NSDictionary * dic1 = @{@"title":@"姓名",@"placeholder":@"请输入您的姓名"};
    NSDictionary * dic2 = @{@"title":@"手机",@"placeholder":@"请输入您的手机号"};
   
    self.dataArray = @[dic1,dic2];
    
    NSDictionary * hDic1 = @{@"title":@"出行人"};
    NSDictionary * hDic2 = @{@"title":@"联系人信息"};
    NSDictionary * hDic3 = @{@"title":@"备注"};

    self.HeaderArray = @[hDic1,hDic2,hDic3];
    
    [FillOrderPersonCell registerCellWithTableView:self.tableView];
    [FillOrderItemCell registerCellWithTableView:self.tableView];
    [FillOrderRemarkCell registerCellWithTableView:self.tableView];
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
