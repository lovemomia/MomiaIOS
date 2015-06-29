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
#import "FillOrderChooseCell.h"
#import "FillOrderMiddleCell.h"
#import "FillOrderBottomCell.h"
#import "CommonHeaderView.h"
#import "FillOrderModel.h"
#import "MOStepperGroup.h"

#define TopNumber 2

static NSString * identifier = @"FillOrderHeaderViewIdentifier";
static NSString * fillOrderTopIdentifier = @"CellFillOrderTop";
static NSString * fillOrderChooseIdentifier = @"CellFillOrderChoose";
static NSString * fillOrderMiddleIdentifier = @"CellFillOrderMiddle";
static NSString * fillOrderBottomIdentifier = @"CellFillOrderBottom";

@interface FillOrderViewController ()

@property(nonatomic, strong) NSArray * dataArray;
@property(nonatomic, strong) NSArray * HeaderArray;
@property(nonatomic, weak) UIView * activeView;
@property(nonatomic, strong) FillOrderModel * model;
@property(nonatomic, strong) NSString * productId;
@property(nonatomic, strong) NSString * utoken;
@property(nonatomic, assign) BOOL isShowAllTopCell;//是否显示所有场次
@property(nonatomic, assign) NSInteger topIndex;

@property(nonatomic, strong) NSMutableArray * currentValueArray;//存储steppterView的当前值，item为NSNumber类型
@property(nonatomic, strong) MOStepperGroup * stepperGroup;

@end

@implementation FillOrderViewController

-(MOStepperGroup *)stepperGroup
{
    if(!_stepperGroup) {
        _stepperGroup = [[MOStepperGroup alloc] init];
    }
    return _stepperGroup;
}

-(NSMutableArray *)currentValueArray
{
    if(!_currentValueArray) {
        _currentValueArray = [[NSMutableArray alloc] init];
    }
    return _currentValueArray;
}

- (IBAction)onSureClick:(id)sender {
    
    NSURL * url = [NSURL URLWithString:@"tq://cashpay"];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - tableView dataSource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
        return 40.0f;
    return 13.0f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view;
    switch (section) {
        case 0:
        {
            CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
            header.data = @"选择场次";
            view = header;
        }
            break;
        case 1:
        {
            CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
            header.data = @"选择出行人数";
            view = header;
        }
            break;
            
        default:
            break;
    }
    
    return view;
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
    NSInteger rows;
    if(section == 0) {
        if(self.model.data.skus.count > TopNumber && !self.isShowAllTopCell) {
            rows = TopNumber + 1;
        } else {
            rows = self.model.data.skus.count;
        }
        
    } else if(section == 1) {
        FillOrderSkuModel * skuModel = self.model.data.skus[self.topIndex];
        rows = skuModel.prices.count;
        [self.currentValueArray removeAllObjects];
        for (int i = 0; i < rows; i++) {
            [self.currentValueArray addObject:@(0)];
        }
    } else {
        rows = 2;
    }
    return rows;
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
            if(row == TopNumber && !self.isShowAllTopCell) {
                FillOrderChooseCell * choose = [FillOrderChooseCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderChooseIdentifier];
                cell = choose;
                
            } else {
                FillOrderTopCell * top = [FillOrderTopCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderTopIdentifier];
                [top setData:self.model.data.skus[row]];
                cell = top;
                
                if(self.topIndex == row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
            break;
        case 1:
        {
            FillOrderMiddleCell * middle = [FillOrderMiddleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderMiddleIdentifier];
            middle.selectionStyle = UITableViewCellSelectionStyleNone;
            FillOrderSkuModel * model = self.model.data.skus[self.topIndex];
            
            NSNumber * cur = self.currentValueArray[row];
            
            [middle setData:model.prices[row] withCurrentValue:cur.integerValue];
            
            middle.stepperView.onclickStepper = ^(NSUInteger currentValue){
                [self.currentValueArray setObject:@(currentValue) atIndexedSubscript:row];
                self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            };
            
            [self.stepperGroup addMOStepperView:middle.stepperView];
            
            cell = middle;
        }
            break;
        default:
        {
            FillOrderBottomCell * bottom = [FillOrderBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderBottomIdentifier];
            [bottom setData:self.model.data.contacts withIndex:row];
            cell = bottom;
          
        }
            break;
    }
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        
        if(row == TopNumber && !self.isShowAllTopCell) {
            self.isShowAllTopCell = YES;
        } else {
            self.topIndex = row;
        }
        
        [self.tableView reloadData];
        
    } else if(section == 2) {
        NSURL * url = [NSURL URLWithString:@"tq://orderperson"];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
  
}

-(CGFloat)totalPrice
{
    CGFloat totalPrice = 0;
    
    FillOrderSkuModel * skuModel = self.model.data.skus[self.topIndex];
    for (int i = 0; i < skuModel.prices.count; i++) {
        FillOrderPriceModel * priceModel = skuModel.prices[i];
        NSNumber * number = self.currentValueArray[i];
        NSInteger count = number.integerValue;
        totalPrice += priceModel.price * count;
    }
    return totalPrice;
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


- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"id":self.productId,@"utoken":self.utoken};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product/order") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[FillOrderModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - view life cycle

-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.productId = [params objectForKey:@"id"];
        self.utoken = [params objectForKey:@"utoken"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"提交订单";
  
    [CommonHeaderView registerCellWithTableView:self.tableView];
    [FillOrderFooterView registerCellWithTableView:self.tableView];
    [FillOrderTopCell registerCellWithTableView:self.tableView withIdentifier:fillOrderTopIdentifier];
    [FillOrderChooseCell registerCellWithTableView:self.tableView withIdentifier:fillOrderChooseIdentifier];
    [FillOrderMiddleCell registerCellWithTableView:self.tableView withIdentifier:fillOrderMiddleIdentifier];
    [FillOrderBottomCell registerCellWithTableView:self.tableView withIdentifier:fillOrderBottomIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    [self requestData];

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
