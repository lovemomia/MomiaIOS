//
//  PackageOrderFillViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectOrderFillViewController.h"
#import "SkuListModel.h"
#import "PostOrderModel.h"
#import "StringUtils.h"
#import "OrderContactViewController.h"

#import "CommonHeaderView.h"
#import "SkuItemCell.h"
#import "CourseSectionTitleCell.h"
#import "PackageHeaderCell.h"

static NSString *identifierSkuItemCell = @"SkuItemCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierPackageHeaderCell = @"PackageHeaderCell";

@interface SubjectOrderFillViewController ()
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *coid;
@property (nonatomic, strong) NSString *coName;
@property (nonatomic, strong) SkuListModel *model;
@end

@implementation SubjectOrderFillViewController

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.ids = [params objectForKey:@"id"];
        self.coid = [params objectForKey:@"coid"];
        self.coName = [params objectForKey:@"coname"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"token:%@",AccountService.defaultService.account.token);
    
    self.navigationItem.title = @"提交订单";
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    [SkuItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSkuItemCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [PackageHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPackageHeaderCell];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic;
    if (self.coid) {
        dic = @{@"id":self.ids, @"coid":self.coid};
    } else {
        dic = @{@"id":self.ids};
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v2/subject/sku") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[SkuListModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        //如果是单次课程，默认数量为1
        if (self.coid && self.model.data.skus.count > 0) {
            Sku *sku = self.model.data.skus[0];
            sku.count = [NSNumber numberWithInt:1];
            [self refreshTotalPrice];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}

- (BOOL)check {
    for (Sku *sku in self.model.data.skus) {
        if (sku.count && [sku.count intValue] > 0) {
            return YES;
        }
    }
    return NO;
}

- (void)postOrder {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"order":[self.model.data toJSONString]};
    
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/subject/order")
                           parameters:params
                       JSONModelClass:[PostOrderModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  
                                  PostOrderModel *order = (PostOrderModel *)responseObject;
                                  
                                  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://cashpay?pom=%@",
                                                                      [[order toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                                  [[UIApplication sharedApplication] openURL:url];
                                  
                                  NSDictionary *dic = @{@"totalPrice":self.priceLabel.text};
                                  [MobClick event:@"OrderFill_Submit" attributes:dic];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshTotalPrice {
    CGFloat totalPrice = 0;
    for (Sku *sku in self.model.data.skus) {
        if (sku.count) {
            totalPrice += (sku.price * [sku.count intValue]);
        }
    }
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", [StringUtils stringForPrice:totalPrice]];
}

#pragma mark - uitableview delegate & datasourse

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0 && self.model.data.packages.count > 0) {
        [self openURL:[NSString stringWithFormat:@"duola://subjectdetail?id=%@", self.ids]];
        
        [MobClick event:@"OrderFill_Subject"];
        
    } else if (indexPath.section == ([self numberOfSectionsInTableView:tableView] - 1)) {
        OrderContactViewController * contactViewController = [[OrderContactViewController alloc] initWithParams:nil];
        contactViewController.model = self.model.data.contact;
        contactViewController.onContactFinishClick = ^{
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:contactViewController animated:YES];
        
        [MobClick event:@"OrderFill_Contact"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        if (self.model.data.packages.count > 0) {
            return 3;
        }
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model) {
        if (section == 0) {
            return self.model.data.skus.count;
        } else if (section == 1 && self.model.data.packages.count > 0) {
            return 1 + self.model.data.packages.count;
            
        } else {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.0;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view;
    if (section == 0) {
        CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
        if (self.coid) {
            header.data = @"购买单次课程";
        } else {
            header.data = @"选择课程包";
        }
        view = header;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        SkuItemCell *skuItemCell = [SkuItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSkuItemCell];
        Sku *sku = self.model.data.skus[indexPath.row];
        skuItemCell.isPackage = self.coid ? NO : YES;
        skuItemCell.data = sku;
        skuItemCell.stepperView.onclickStepper = ^(NSUInteger currentValue){
            sku.count = [NSNumber numberWithInteger:currentValue];
            [self refreshTotalPrice];
        };
        skuItemCell.stepperView.hidden = NO;
        if ([sku.limit intValue] > 0) {
            skuItemCell.stepperView.maxValue = [sku.limit intValue];
        } else {
            skuItemCell.stepperView.maxValue = NSIntegerMax;
        }
        cell = skuItemCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (indexPath.section == 1 && self.model.data.packages.count > 0) {
        if (indexPath.row == 0) {
            PackageHeaderCell *headerCell = [PackageHeaderCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPackageHeaderCell];
            headerCell.data = self.coName;
            headerCell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
            headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = headerCell;
            
        } else {
            SkuItemCell *skuItemCell = [SkuItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSkuItemCell];
            Sku *sku = self.model.data.packages[indexPath.row - 1];
            skuItemCell.isPackage = YES;
            skuItemCell.data = sku;
            skuItemCell.stepperView.hidden = YES;
            cell = skuItemCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    } else {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"联系人信息";
        titleCell.subTitleLabel.text = self.model.data.contact.mobile;
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        titleCell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        cell = titleCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [SkuItemCell heightWithTableView:tableView withIdentifier:identifierSkuItemCell forIndexPath:indexPath data:nil];
        
    } else if (indexPath.section == 1 && self.model.data.packages.count > 0) {
        if (indexPath.row == 0) {
            return 44;
            
        } else {
            return [SkuItemCell heightWithTableView:tableView withIdentifier:identifierSkuItemCell forIndexPath:indexPath data:nil];
        }
        
    } else {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
    }
}

- (IBAction)onOkClicked:(id)sender {
    if (self.model == nil) {
        return;
    }
    
    if ([self check]) {
        [self postOrder];
    } else {
        [self showDialogWithTitle:nil message:@"您还没有选择课程包"];
    }
}

@end
