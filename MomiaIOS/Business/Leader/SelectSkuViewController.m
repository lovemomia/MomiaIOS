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

static NSString *myFavCellIdentifier = @"MyFavCell";
static NSString *selectSkuCellIdentifier = @"SelectSkuCell";

@interface SelectSkuViewController()
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) LeaderSkuModel *model;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation SelectSkuViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.pid = [params objectForKey:@"pid"];
    }
    return self;
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
                                                     [self.tableView reloadData];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self.view removeLoadingBee];
                                                     [self showDialogWithTitle:nil message:error.message];
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = selectSkuCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [MyFavCell heightWithTableView:tableView withIdentifier:myFavCellIdentifier forIndexPath:indexPath data:self.model.data.product];
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

@end
