//
//  ShareViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/17.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ShareViewController.h"
#import "CouponShareModel.h"
#import "ShareViewCell.h"

static NSString *identifierShareViewCell = @"ShareViewCell";

@interface ShareViewController ()
@property (nonatomic, strong) CouponShareModel *model;
@end

@implementation ShareViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"邀请好友";
    
    [ShareViewCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierShareViewCell];
    
    [self requestData];
    
}

- (void)requestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/coupon/share")
                          parameters:nil cacheType:CacheTypeDisable JSONModelClass:[CouponShareModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 self.model = (CouponShareModel *)responseObject;
                                 [self.tableView reloadData];
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareViewCell *cell = [ShareViewCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierShareViewCell];
    cell.data = self.model.data;
    return cell;
}

@end
