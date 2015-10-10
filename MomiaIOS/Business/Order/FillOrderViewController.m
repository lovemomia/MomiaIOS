//
//  FillOrderViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderViewController.h"
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
#import "OrderContactViewController.h"
#import "PostOrderModel.h"
#import "StringUtils.h"

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
@property(nonatomic, strong) NSArray *showSkus;

@property(nonatomic, assign) BOOL isShowAllTopCell;//是否显示所有场次
@property(nonatomic, assign) NSInteger topIndex;
@property(nonatomic, assign) BOOL needRealName;

@property(nonatomic, strong) MOStepperGroup * stepperGroup;
@property(nonatomic, strong) NSMutableArray * middleCellArray;

@property(nonatomic, assign) BOOL middleDataChanged;

@property(nonatomic, strong) AddOrderModel * orderModel;//提交订单的model

@property(nonatomic, strong) NSMutableDictionary * selectedDictionary;

@property(nonatomic, strong) NSMutableArray *selectPlaceSkus;
@property(nonatomic, assign) BOOL isShowPlaces;
@property(nonatomic, strong) FillOrderPlaceModel *selectedPlace;
@end

@implementation FillOrderViewController

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(-1, 0, 0, 0);
}

- (UIEdgeInsets)separatorInset {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,10,0,0);
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:[self separatorInset]];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:[self separatorInset]];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
}

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

- (IBAction)onSureClick:(id)sender {
    
    self.middleDataChanged = NO;
    
    //确认订单
    PersonStyle middlePersonStyle = self.personCount;
    PersonStyle bottomPersonStyle = self.selectedPersonStyle;
    if(!self.orderModel) {
        [AlertNotice showNotice:@"订单信息不存在"];
        return;
    }
    
    if(!middlePersonStyle.adult && !middlePersonStyle.child) {
        [AlertNotice showNotice:@"您选择的出行人数为零"];
        return;
    }
    if(self.needRealName && (middlePersonStyle.adult != bottomPersonStyle.adult || middlePersonStyle.child != bottomPersonStyle.child)) {
        [AlertNotice showNotice:@"选择的出行人不合要求，请重新选择"];
        return;
    }
    
    self.orderModel.contacts = self.model.data.contacts.name;
    self.orderModel.mobile = self.model.data.contacts.mobile;
    
    if(self.orderModel.contacts.length == 0) {
        [AlertNotice showNotice:@"联系人姓名不能为空"];
        return;
    }
    
    if(self.orderModel.mobile.length == 0) {
        [AlertNotice showNotice:@"联系人电话号码不能为空"];
        return;
    }
    
    self.orderModel.prices = (NSArray<AddOrderPriceModel> *)self.prices;
    self.orderModel.participants = self.participants;
    
    [self postOrder];
    
}


-(void)postOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"addordermodel:%@",self.orderModel.toJSONString);
    NSDictionary *params = @{@"order":[self.orderModel toJSONString]};
    
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/order")
                           parameters:params
                       JSONModelClass:[PostOrderModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  
                                  PostOrderModel *order = (PostOrderModel *)responseObject;
                               
                                  NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://cashpay?pom=%@",
                                                                      [[order toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
    NSInteger sec = section;
    if (self.isShowPlaces) {
        sec--;
    }
    if(sec <= 0)
        return 40.0f;
    if(sec == 1) {
        FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
        if(skuModel.stock > 0) {
            return 40.0f;
        } else {
            return 0.1f;
        }
    }
    return 13.0f;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger sec = section;
    if (self.isShowPlaces) {
        sec--;
    }
    UITableViewHeaderFooterView * view;
    switch (sec) {
        case -1:
        {
            CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
            header.data = @"选择区域";
            view = header;
        }
            break;
        case 0:
        {
            CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
            header.data = @"选择场次";
            view = header;
        }
            break;
        case 1:
        {
            FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
            if(skuModel.stock > 0) {
                CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
                header.data = @"选择出行人数";
                view = header;
            }
        }
            break;
            
        default:
            break;
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) {
        if (self.isShowPlaces) {
            return 4;
        }
        return 3;
    }
    else return 0;
}

-(NSInteger)indexForFirstTopIndex
{
    NSInteger topIndex = 0;
    if(self.model) {
        for (int i = 0; i < self.showSkus.count; i++) {
            FillOrderSkuModel * model = self.model.data.skus[i];
            if(model.type == 1) {//无上限，不显示stock
                topIndex = i;
                break;
            } else {//有上限
                if(model.stock == 0) {//名额已满
                    
                } else {//还剩XX名额
                    topIndex = i;
                    break;
                }
            }
            
        }
    }
    return topIndex;
}

-(BOOL)isFullWithIndex:(NSInteger)index
{
    BOOL isFull = NO;
    
    if(self.model) {
        if(index < self.showSkus.count) {
            FillOrderSkuModel * model = self.showSkus[index];
            if(model.type == 1) {//无上限，不显示stock
               
            } else {//有上限
                if(model.stock == 0) {//名额已满
                    isFull = YES;
                } else {//还剩XX名额
                   
                }
            }

        }
    }
    return isFull;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sec = section;
    if (self.isShowPlaces) {
        sec--;
    }
    NSInteger rows;
    if (sec == -1) {
        return [self.model.data.places count];
        
    } else if (sec == 0) {
        NSInteger count = self.showSkus.count;
        if(count > TopNumber && !self.isShowAllTopCell) {
            rows = TopNumber + 1;
        } else {
            rows = count;
        }
    } else if(sec == 1) {
        FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
        if(skuModel.stock > 0)
            rows = skuModel.prices.count;
        else rows = 0;//库存为零
        if(self.middleDataChanged) {
            //设置orderModel的productId和skuId属性
            self.orderModel.productId = skuModel.productId;
            self.orderModel.skuId = skuModel.skuId;
            [self.selectedDictionary removeAllObjects];
            
            NSInteger maxPlace = 0;
            
            if(skuModel.type == 1) {//无上限，不显示stock
                if(skuModel.limit ==0) {//每人不限单购买
                    maxPlace = LONG_MAX;
                } else {//每人限单购买
                    maxPlace = skuModel.limit;
                }
                
            } else {//有上限
                if(skuModel.stock == 0) {//名额已满
                    
                    
                } else {//还剩XX名额
                    
                }
                
                if(skuModel.limit == 0) {//每人不限单购买
                    maxPlace = skuModel.stock;
                } else {//每人限单购买
                    maxPlace = MIN(skuModel.stock, skuModel.limit);
                }
                
            }
            
            [self.stepperGroup setMaxPlaces:maxPlace];
            
            [self.stepperGroup removeAllSteppers];
            [self.middleCellArray removeAllObjects];
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[StringUtils stringForPrice:self.totalPrice]];
            for (int i = 0; i < rows; i++) {
                FillOrderMiddleCell * middle = [ConvertFromXib convertObjectWithNibNamed:@"FillOrderMiddleCell" withClassNamed:NSStringFromClass([FillOrderMiddleCell class])];
                [self.stepperGroup addMOStepperView:middle.stepperView];
                [self.middleCellArray addObject:middle];
            }
        }
    } else {
        /**
         *2015-07-08修改，"needRealName":// 是否实名，如果为true，需要填写出行人信息
         */
        FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
        if(skuModel.needRealName)
            rows = 2;
        else rows = 1;
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
    if (self.isShowPlaces) {
        section--;
    }
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    switch (section) {
        case -1:
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            FillOrderPlaceModel *place = [self.model.data.places objectAtIndex:row];
            UILabel *titleLabel = [UILabel new];
            [titleLabel setText:place.name];
            titleLabel.font = [UIFont systemFontOfSize:14];
            [titleLabel setTextColor:UIColorFromRGB(0x333333)];
            
            [cell addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            
            cell.tintColor = MO_APP_ThemeColor;
            if ([self.selectedPlace isEqual:place]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case 0:
        {
            if(row == TopNumber && !self.isShowAllTopCell) {
                FillOrderChooseCell * choose = [FillOrderChooseCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderChooseIdentifier];
                cell = choose;
                
            } else {
                FillOrderTopCell * top = [FillOrderTopCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderTopIdentifier];
                FillOrderSkuModel *sku = self.showSkus[row];
                [top setData:sku];
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
            FillOrderSkuModel * model = self.showSkus[self.topIndex];
            
            [middle setData:model.prices[row]];
            
            middle.stepperView.onclickStepper = ^(NSUInteger currentValue){//单击+、-事件响应
                [self.stepperGroup refreshStatus];//更新stepper组件
                self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[StringUtils stringForPrice:self.totalPrice]];
            };
            
            cell = middle;
        }
            break;
        default:
        {
            FillOrderBottomCell * bottom = [FillOrderBottomCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:fillOrderBottomIdentifier];
            
            FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
            
            NSString * personStr = @"";
            if(self.selectedPersonStyle.adult > 0) {
                personStr = [personStr stringByAppendingFormat:@"%ld成人",(unsigned long)self.selectedPersonStyle.adult];
            }
            if(self.selectedPersonStyle.child > 0) {
                personStr = [personStr stringByAppendingFormat:@"%ld儿童",(unsigned long)self.selectedPersonStyle.child];
            }
            [bottom setData:self.model.data.contacts withIndex:row andPersonStr:personStr andSkuModel:skuModel];
            cell = bottom;
        }
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.middleDataChanged = NO;// it's a bug for ios 8.2 push a controller will force table reloadData
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (self.isShowPlaces) {
        section--;
    }
    
    if (section == -1) {
        FillOrderPlaceModel *place = self.model.data.places[row];
        if ([place isEqual:self.selectedPlace]) {
            return;
        }
        self.selectedPlace = place;
        [self resetSelectPlaceSkus];
        self.topIndex = [self indexForFirstTopIndex]; // reset selectSku
        FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
        self.needRealName = skuModel.needRealName;
        self.middleDataChanged = YES;
        self.isShowAllTopCell = NO;
        [self.tableView reloadData];
        
    } else if(section == 0) {
        
        if(row == TopNumber && !self.isShowAllTopCell) {//表明点击的是选择其他场次，需要刷新table，但是middle不能改变
            self.isShowAllTopCell = YES;
            self.middleDataChanged = NO;
            [self.tableView reloadData];
        } else {
            if(self.topIndex != row) {//表明点击的是不同行，需要刷新
                if([self isFullWithIndex:row]) {//单击的这一行名额已满
                    
                } else {
                    self.topIndex = row;
                    FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
                    self.needRealName = skuModel.needRealName;
                    self.middleDataChanged = YES;
                    [self.tableView reloadData];
                }
            }
        }
        
    } else if(section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if(row == 0 && self.needRealName) {//单击出行人
            PersonStyle personStyle = self.personCount;
            if(!personStyle.adult && !personStyle.child) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"您选择的出行人数为零";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
            } else {
                OrderPersonViewController * controller = [[OrderPersonViewController alloc] initWithNibName:@"OrderPersonViewController" bundle:nil];
//                controller.utoken = self.utoken;
                controller.personStyle = personStyle;
                controller.selectedDictionary = self.selectedDictionary;
                controller.onFinishClick = ^() {
                    self.middleDataChanged = NO;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        } else {//单击联系人信息
            OrderContactViewController * contactViewController = [[OrderContactViewController alloc] initWithParams:nil];
            contactViewController.model = self.model.data.contacts;
            contactViewController.onContactFinishClick = ^{
                self.middleDataChanged = NO;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:contactViewController animated:YES];

            
        }
    }
}

-(PersonStyle)personCount
{
    PersonStyle personStyle = {0,0};
    
    FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
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
    FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
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
    FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
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



- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
        
    NSDictionary * dic = @{@"id":self.productId};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product/order") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[FillOrderModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;

        FillOrderSkuModel * skuModel = self.showSkus[self.topIndex];
        self.needRealName = skuModel.needRealName;
        
        if (self.model.data.places && [self.model.data.places count] > 0) {
            self.isShowPlaces = YES;
            self.selectedPlace = [self.model.data.places objectAtIndex:0];
            self.selectPlaceSkus = [NSMutableArray new];
            [self resetSelectPlaceSkus];
            self.showSkus = self.selectPlaceSkus;
            
        } else {
            self.showSkus = self.model.data.skus;
        }
        
        self.topIndex = [self indexForFirstTopIndex];
        //在请求到SKU信息后开始为AddOrderModel分配空间并初始化
        self.orderModel = [[AddOrderModel alloc] init];
        //设置orderModel的contacts和mobile属性
        self.middleDataChanged = YES;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}

- (void)resetSelectPlaceSkus {
    if (!self.selectedPlace || !self.model) {
        return;
    }
    
    [self.selectPlaceSkus removeAllObjects];
    for (FillOrderSkuModel *sku in self.model.data.skus) {
        if (sku.placeId && [sku.placeId isEqualToNumber:self.selectedPlace.ids]) {
            [self.selectPlaceSkus addObject:sku];
        }
    }
}

#pragma mark - view life cycle

-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.productId = [params objectForKey:@"id"];
//        self.utoken = [params objectForKey:@"utoken"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"token:%@",AccountService.defaultService.account.token);
    
    self.navigationItem.title = @"提交订单";
  
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    [FillOrderTopCell registerCellFromNibWithTableView:self.tableView withIdentifier:fillOrderTopIdentifier];
    [FillOrderChooseCell registerCellFromNibWithTableView:self.tableView withIdentifier:fillOrderChooseIdentifier];
    [FillOrderBottomCell registerCellFromNibWithTableView:self.tableView withIdentifier:fillOrderBottomIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[StringUtils stringForPrice:self.totalPrice]];
    
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
