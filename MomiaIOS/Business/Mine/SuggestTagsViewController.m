//
//  SuggestTagsViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SuggestTagsViewController.h"
#import "SugTagsCell.h"
#import "SugTagsModel.h"

@interface SuggestTagsViewController ()

@end

@implementation SuggestTagsViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishClicked)];
    
    if (self.assorts && self.crowds) {
        [self.tableView reloadData];
    } else {
        [self requestData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

// 确定按钮点击
- (void)onFinishClicked {
    if (self.assorts == nil || self.crowds == nil) {
        return;
    }
    
    if (self.delegate) {
        [self.delegate onChooseFinishWithAssorts:self.assorts andCrowds:self.crowds];
    }
}

- (void)requestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/assort?type=1") parameters:nil cacheType:CacheTypeNormal JSONModelClass:[SugTagsModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SugTagsModel *result = responseObject;
        self.assorts = result.data.assorts;
        self.crowds = result.data.crowds;
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* content = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 30)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        titleLabel.text = @"分类";
        titleLabel.height = 40;
        titleLabel.top = 15;
    } else {
        titleLabel.text = @"适用人群";
        titleLabel.height = 20;
        titleLabel.top = 5;
    }
    [content addSubview:titleLabel];
    return content;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.assorts) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.assorts) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SugTagsCell *cell;
    if (indexPath.section == 0) {
        cell = [SugTagsCell cellWithTableView:tableView withData:self.assorts];
    } else {
        cell = [SugTagsCell cellWithTableView:tableView withData:self.crowds];
    }
    return cell;
}

@end
