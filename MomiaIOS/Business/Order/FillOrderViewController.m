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
#import "ConvertFromXib.h"
#import "AddOrderModel.h"
#import "OrderPersonViewController.h"
#import "PostOrderModel.h"

#define TopNumber 2

static NSString * identifier = @"FillOrderHeaderViewIdentifier";
static NSString * fillOrderTopIdentifier = @"CellFillOrderTop";
static NSString * fillOrderChooseIdentifier = @"CellFillOrderChoose";
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

@property(nonatomic, strong) MOStepperGroup * stepperGroup;
@property(nonatomic, strong) NSMutableArray * middleCellArray;

@property(nonatomic, assign) BOOL middleDataChanged;

@property(nonatomic, strong) AddOrderModel * orderModel;//提交订单的model

@property(nonatomic, strong) NSMutableDictionary * selectedDictionary;

@end

@implementation FillOrderViewController

-(NSMutableDictionary *)selectedDictionary
{
    if(!_selectedDictionary) {
        _selectedDictionary = [[NSMutableDictionary alloc] init];
    }
    return _selectedDictionary;
}


-(NSMutableArray *)middleCellArray
{
    if(!_middleCellArray) {
        _middleCellArray = [[NSMutableArray alloc] init];
    }
    return _middleCellArray;
}

-(MOStepperGroup *)stepperGroup
{
    if(!_stepperGroup) {
        _stepperGroup = [[MOStepperGroup alloc] init];
    }
    return _stepperGroup;
}

//-(NSMutableArray *)currentValueArray
//{
//    if(!_currentValueArray) {
//        _currentValueArray = [[NSMutableArray alloc] init];
//    }
//    return _currentValueArray;
//}

- (IBAction)onSureClick:(id)sender {
    
    //确认订单
    PersonStyle middlePersonStyle = self.personCount;
    PersonStyle bottomPersonStyle = self.selectedPersonStyle;
    if(!self.orderModel) {
        [AlertNotice showNotice:@"订单信息不存在"];
        return;
    }
    
    if(!middlePersonStyle.adult && !middlePersonStyle.child) {
        [AlertNotice showNotice:@"您还未选择出行人"];
        return;
    }
    if(middlePersonStyle.adult != bottomPersonStyle.adult || middlePersonStyle.child != bottomPersonStyle.child) {
        [AlertNotice showNotice:@"选择的出行人不合要求，请重新选择"];
        return;
    }
    self.orderModel.prices = self.prices;
    self.orderModel.participants = self.participants;
    
    [self postOrder];
    
}


-(void)postOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"utoken":self.utoken,@"order":[self.orderModel toJSONString]};
    
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/order")
                           parameters:params
                       JSONModelClass:[PostOrderModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                               
                                  NSURL * url = [NSURL URLWithString:@"tq://cashpay"];
                                  [[UIApplication sharedApplication] openURL:url];

                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
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
    if(self.model)
        return 3;
    else return 0;
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
        if(skuModel.stock > 0)
            rows = skuModel.prices.count;
        else rows = 0;//库存为零
        if(self.middleDataChanged) {
            //设置orderModel的productId和skuId属性
            self.orderModel.productId = skuModel.productId;
            self.orderModel.skuId = skuModel.skuId;
            [self.selectedDictionary removeAllObjects];
            [self.stepperGroup setMaxPlaces:skuModel.stock];
            [self.stepperGroup removeAllSteppers];
            [self.middleCellArray removeAllObjects];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            for (int i = 0; i < rows; i++) {
                FillOrderMiddleCell * middle = [ConvertFromXib convertObjectWithNibNamed:@"FillOrderMiddleCell" withClassNamed:NSStringFromClass([FillOrderMiddleCell class])];
                [self.stepperGroup addMOStepperView:middle.stepperView];
                [self.middleCellArray addObject:middle];
            }
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
            FillOrderMiddleCell * middle = [self.middleCellArray objectAtIndex:row];
            middle.selectionStyle = UITableViewCellSelectionStyleNone;
            FillOrderSkuModel * model = self.model.data.skus[self.topIndex];
            
            [middle setData:model.prices[row]];
            
            middle.stepperView.onclickStepper = ^(NSUInteger currentValue){//单击+、-事件响应
                [self.stepperGroup refreshStatus];//更新stepper组件
                self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
            };
            
            cell = middle;
        }
            break;
        default:
        {
            FillOrderBottomCell * bottom = [FillOrderBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderBottomIdentifier];
            NSString * personStr = @"";
            if(self.selectedPersonStyle.adult > 0) {
                personStr = [personStr stringByAppendingFormat:@"%ld成人",self.selectedPersonStyle.adult];
            }
            if(self.selectedPersonStyle.child > 0) {
                personStr = [personStr stringByAppendingFormat:@"%ld儿童",self.selectedPersonStyle.child];
            }
            [bottom setData:self.model.data.contacts withIndex:row andPersonStr:personStr];
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
        
        if(row == TopNumber && !self.isShowAllTopCell) {//表明点击的是选择其他场次，需要刷新table，但是middle不能改变
            self.isShowAllTopCell = YES;
            self.middleDataChanged = NO;
            [self.tableView reloadData];
        } else {
            if(self.topIndex != row) {//表明点击的是不同行，需要刷新
                self.topIndex = row;
                self.middleDataChanged = YES;
                [self.tableView reloadData];
            }
        }
        
    } else if(section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(row == 0) {//单击出行人
            PersonStyle personStyle = self.personCount;
            if(!personStyle.adult && !personStyle.child) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"您还未选择出行人";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            } else {
                OrderPersonViewController * controller = [[OrderPersonViewController alloc] initWithNibName:@"OrderPersonViewController" bundle:nil];
                controller.utoken = self.utoken;
                controller.personStyle = personStyle;
                controller.selectedDictionary = self.selectedDictionary;
                controller.onFinishClick = ^() {
                    self.middleDataChanged = NO;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        } else {//单击联系人信息
            
        }
    }
}

-(PersonStyle)personCount
{
    PersonStyle personStyle = {0,0};
    
    FillOrderSkuModel * skuModel = self.model.data.skus[self.topIndex];
    for (int i = 0; i < skuModel.prices.count; i++) {
        FillOrderPriceModel * priceModel = skuModel.prices[i];
        MOStepperView * stepper = [self.stepperGroup objectAtIndex:i];
        personStyle.adult += priceModel.adult * stepper.currentValue;
        personStyle.child += priceModel.child * stepper.currentValue;
    }
    
    return personStyle;
}


-(PersonStyle)selectedPersonStyle
{
    PersonStyle personStyle = {0,0};
    NSArray * allKeys = self.selectedDictionary.allKeys;
    for(id number in allKeys) {
        if([self.selectedDictionary[number] isEqualToString:@"儿童"])
            personStyle.child ++;
        else personStyle.adult++;
    }
    return personStyle;
    
}



-(CGFloat)totalPrice
{
    CGFloat totalPrice = 0;
    FillOrderSkuModel * skuModel = self.model.data.skus[self.topIndex];
    for (int i = 0; i < skuModel.prices.count; i++) {
        FillOrderPriceModel * priceModel = skuModel.prices[i];
        MOStepperView * stepper = [self.stepperGroup objectAtIndex:i];
        NSInteger count = stepper.currentValue;
        totalPrice += priceModel.price * count;
    }
    return totalPrice;
}

-(NSArray *)prices//用来计算orderModel的prices属性
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    FillOrderSkuModel * skuModel = self.model.data.skus[self.topIndex];
    for (int i = 0; i < skuModel.prices.count; i++) {
        FillOrderPriceModel * priceModel = skuModel.prices[i];
        MOStepperView * stepper = [self.stepperGroup objectAtIndex:i];
        if(stepper.currentValue > 0) {//表明选择了相应的数目
            AddOrderPriceModel * addOrderPriceModel = [[AddOrderPriceModel alloc] init];
            addOrderPriceModel.count = stepper.currentValue;
            addOrderPriceModel.price = priceModel.price;
            if(priceModel.adult > 0) addOrderPriceModel.adult = @(priceModel.adult);
            if(priceModel.child > 0) addOrderPriceModel.child = @(priceModel.child);
            [array addObject:addOrderPriceModel];
        }
    }
    return array;
}

-(NSArray *)participants//用来计算orderModel的participants属性
{
    NSArray * allKeys = self.selectedDictionary.allKeys;
    return allKeys;
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
        
        //在请求到SKU信息后开始为AddOrderModel分配空间并初始化
        self.orderModel = [[AddOrderModel alloc] init];
        //设置orderModel的contacts和mobile属性
        self.orderModel.contacts = self.model.data.contacts.name;
        self.orderModel.mobile = self.model.data.contacts.mobile;
        
        self.middleDataChanged = YES;

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
    [FillOrderBottomCell registerCellWithTableView:self.tableView withIdentifier:fillOrderBottomIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalPrice];
    
    [self requestData];
    
    self.orderModel = [[AddOrderModel alloc] init];
    self.orderModel.productId = 25;

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
