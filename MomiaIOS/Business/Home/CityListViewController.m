//
//  CityListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CityListViewController.h"
#import "CityListModel.h"
#import "CommonHeaderView.h"
#import "CityManager.h"

@interface CityListViewController ()

@property (nonatomic, strong) NSArray *cityList;

@end

@implementation CityListViewController

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"选择城市-%@", [CityManager shareManager].choosedCity.name];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"TitleCancel"]];
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    
    [self requestData];
}

- (void)onCancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    [self.view showLoadingBee];
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/city") parameters:nil cacheType:CacheTypeNormal JSONModelClass:[CityListModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view removeLoadingBee];
        
        self.cityList = ((CityListModel *)responseObject).data;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
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

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.cityList objectAtIndex:indexPath.row];
    [CityManager shareManager].choosedCity = city;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityList ? [self.cityList count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *CellDefault = @"CellDefault";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellDefault];
    }
    City *city = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
    header.data = @"已开通城市列表";
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect frameRect = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更多城市即将开通"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,8)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,8)];
    label.attributedText = str;
    label.textAlignment = UIBaselineAdjustmentAlignCenters;
    return label;
}

@end
