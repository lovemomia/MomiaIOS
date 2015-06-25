//
//  FillOrderViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderViewController.h"
#import "FillOrderFooterView.h"
#import "FillOrderTopCell.h"
#import "FillOrderMiddleCell.h"
#import "FillOrderBottomCell.h"
#import "CommonHeaderView.h"

static NSString * identifier = @"FillOrderHeaderViewIdentifier";
static NSString * fillOrderTopIdentifier = @"CellFillOrderTop";
static NSString * fillOrderMiddleIdentifier = @"CellFillOrderMiddle";
static NSString * fillOrderBottomIdentifier = @"CellFillOrderBottom";



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
    return 40.0f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView * cell = [CommonHeaderView cellWithTableView:self.tableView];
    cell.data = @"选择场次";
    return cell;
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
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    switch (section) {
        case 0:
        {
            FillOrderTopCell * top = [FillOrderTopCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderTopIdentifier];
            cell = top;
        }
            break;
        case 1:
        {
            FillOrderMiddleCell * middle = [FillOrderMiddleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderMiddleIdentifier];
            middle.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = middle;
        }
            break;
        default:
        {
            FillOrderBottomCell * bottom = [FillOrderBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderBottomIdentifier];
            cell = bottom;
          
        }
            break;
    }
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL * url = [NSURL URLWithString:@"tq://orderperson"];
    [[UIApplication sharedApplication] openURL:url];

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
  
    [CommonHeaderView registerCellWithTableView:self.tableView];
    [FillOrderFooterView registerCellWithTableView:self.tableView];
    [FillOrderTopCell registerCellWithTableView:self.tableView withIdentifier:fillOrderTopIdentifier];
    [FillOrderMiddleCell registerCellWithTableView:self.tableView withIdentifier:fillOrderMiddleIdentifier];
    [FillOrderBottomCell registerCellWithTableView:self.tableView withIdentifier:fillOrderBottomIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);

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
