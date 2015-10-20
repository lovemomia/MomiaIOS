//
//  ProductCalendarMonthViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarMonthViewController.h"
#import "BookSkuDateTitleCell.h"
#import "ProductCalendarCell.h"
#import "ProductCalendarModel.h"

static NSString * productCalendarMonthTitleIdentifier = @"CellProductCalendarMonthTitle";
static NSString * productCalendarMonthIdentifier = @"CellProductCalendarMonth";

@interface ProductCalendarMonthViewController ()

@property(nonatomic,strong) ProductCalendarMonthModel * model;
@property(nonatomic,assign) int month;

@end

@implementation ProductCalendarMonthViewController

-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

-(UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProductCalendarMonthDataModel * model = self.model.data[section];
    return 1 + model.products.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0) {
        return 46;
    }
    return 104.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == 0) {
        BookSkuDateTitleCell * title = [BookSkuDateTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarMonthTitleIdentifier];
        [title setData:self.model.data[section]];
        title.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = title;
    } else {
        ProductCalendarCell * content = [ProductCalendarCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarMonthIdentifier];
        ProductCalendarMonthDataModel * dataModel = self.model.data[section];
        [content setData:dataModel.products[row - 1]];
        cell = content;
    }
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == 0) {
        
    } else {
        ProductCalendarMonthDataModel * dataModel = self.model.data[section];
        ProductModel * model = dataModel.products[row - 1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://productdetail?id=%ld", (long)model.pID]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - webData Request

- (void)requestData {
    
    [self.view removeEmptyView];
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"city":@1,@"month":@(self.month)};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product/month") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[ProductCalendarMonthModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        
        self.model = responseObject;
        
        if(self.model.data.count > 0) {
            [self.tableView reloadData];
        } else {
            [self.view showEmptyView:@"还没有活动，敬请期待哦！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}

-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        NSNumber * num = [params objectForKey:@"month"];
        self.month = [num intValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BookSkuDateTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:productCalendarMonthTitleIdentifier];
    [ProductCalendarCell registerCellFromNibWithTableView:self.tableView withIdentifier:productCalendarMonthIdentifier];
    
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
