//
//  SelectSkuViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/4.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SelectSkuViewController.h"
#import "LeaderSkuModel.h"
#import "ProductModel.h"
#import "MyFavCell.h"
#import "SelectSkuCell.h"
#import "LeaderStatusViewController.h"
#import "UIImage+Color.h"

static NSString *myFavCellIdentifier = @"MyFavCell";
static NSString *selectSkuCellIdentifier = @"SelectSkuCell";

@interface SelectSkuViewController()
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) LeaderSkuModel *model;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *okButton;
@end

@implementation SelectSkuViewController
@synthesize okButton;

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.pid = [params objectForKey:@"pid"];
    }
    return self;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,10,0,0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择场次";
    
    [MyFavCell registerCellWithTableView:self.tableView withIdentifier:myFavCellIdentifier];
    [SelectSkuCell registerCellWithTableView:self.tableView withIdentifier:selectSkuCellIdentifier];
    
    [self requestData];
}

- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    [self.view showLoadingBee];
    
    NSDictionary * paramDic = @{@"pid":self.pid};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/product/sku/leader")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[LeaderSkuModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [self.view removeLoadingBee];
                                                     
                                                     self.model = (LeaderSkuModel *)responseObject;
                                                     
                                                     [self addFootButton];
                                                     self.selectIndex = -1;
                                                     [self.tableView reloadData];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self.view removeLoadingBee];
                                                     [self showDialogWithTitle:nil message:error.message];
                                                 }];
}

- (void)addFootButton {
    okButton = [[UIButton alloc]init];
    [okButton setTitle:@"成为领队" forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageWithColor:MO_APP_ThemeColor size:CGSizeMake(self.view.width, 50)] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xcccccc) size:CGSizeMake(self.view.width, 50)] forState:UIControlStateDisabled];
    [okButton addTarget:self action:@selector(onOKClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    okButton.enabled = NO;
}

- (void)onOKClicked {
    if (self.model == nil || self.model.data.skus.count == 0) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    LeaderSku *sku = [self.model.data.skus objectAtIndex:self.selectIndex];
    NSDictionary * paramDic = @{@"pid":self.pid, @"sid":[NSString stringWithFormat:@"%ld", (long)sku.skuId]};
    self.curOperation = [[HttpService defaultService]POST:URL_APPEND_PATH(@"/leader/apply")
                                               parameters:paramDic JSONModelClass:[BaseModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     
                                                     [[NSNotificationCenter defaultCenter]postNotificationName:@"leaderDataChanged" object:nil];
                                                     [self showDialogWithTitle:nil message:@"申请成功" tag:1001];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self.view removeLoadingBee];
                                                     [self showDialogWithTitle:nil message:error.message];
                                                 }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LeaderStatusViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self openURL:[NSString stringWithFormat:@"duola://productdetail?id=%ld", (long)self.model.data.product.pID]];
        
    } else {
        LeaderSku *sku = [self.model.data.skus objectAtIndex:indexPath.row];
        if (sku.hasLeader) {
            return;
            
        } else {
            self.selectIndex = indexPath.row;
            [self.tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model == nil) {
        return 0;
    }
    if (section == 0) {
        return 1;
    }
    return [self.model.data.skus count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model == nil) {
        return 0;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if(indexPath.section == 0) {
        MyFavCell * itemCell = [MyFavCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:myFavCellIdentifier];
        itemCell.data = self.model.data.product;
        cell = itemCell;
        
    } else {
        SelectSkuCell *selectSkuCell = [SelectSkuCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:selectSkuCellIdentifier];
        selectSkuCell.data = [self.model.data.skus objectAtIndex:indexPath.row];
        if(self.selectIndex == indexPath.row) {
            selectSkuCell.accessoryType = UITableViewCellAccessoryCheckmark;
            okButton.enabled = YES;
        } else {
            selectSkuCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = selectSkuCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 87;
    }
    return [SelectSkuCell heightWithTableView:tableView withIdentifier:selectSkuCellIdentifier forIndexPath:indexPath data:[self.model.data.skus objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

@end
