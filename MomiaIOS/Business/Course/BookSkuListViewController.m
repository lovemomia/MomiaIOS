//
//  BookSkuListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookSkuListViewController.h"

#import "BookSkuItemCell.h"
#import "BookSkuMoreCell.h"
#import "BookSkuDateTitleCell.h"

static NSString *identifierBookSkuItemCell = @"BookSkuItemCell";
static NSString *identifierBookSkuMoreCell = @"BookSkuMoreCell";
static NSString *identifierBookSkuDateTitleCell = @"BookSkuDateTitleCell";

@interface BookSkuListViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) BOOL onlyShow;
@property (nonatomic, assign) BOOL isRequestMonth;

@property (nonatomic, strong) CourseSkuListModel * model;
@property (nonatomic, assign) NSInteger selectSection;
@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation BookSkuListViewController

-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.ids = [params objectForKey:@"id"];
        self.onlyShow = [[params objectForKey:@"onlyshow"]boolValue];
        NSNumber * num = [params objectForKey:@"month"];
        if (num) {
            self.isRequestMonth = YES;
            self.month = [num intValue];
        }
        self.selectSection = -1;
        self.selectRow = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BookSkuDateTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierBookSkuDateTitleCell];
    [BookSkuItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierBookSkuItemCell];
    [BookSkuMoreCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierBookSkuMoreCell];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearChooseStatus {
    self.selectSection = -1;
    self.selectRow = -1;
    [self.tableView reloadData];
}

#pragma mark - webData Request

- (void)requestData {
    
    [self.view removeEmptyView];
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic;
    NSString *path;
    if (self.isRequestMonth) {
        path = self.onlyShow ? @"/course/sku/month/notend" : @"/course/sku/month/bookable";
        dic = @{@"id":self.ids, @"month":@(self.month)};
    } else {
        path = self.onlyShow ? @"/course/sku/week/notend" : @"/course/sku/week/bookable";
        dic = @{@"id":self.ids};
    }
    [[HttpService defaultService] GET:URL_APPEND_PATH(path) parameters:dic cacheType:CacheTypeDisable JSONModelClass:[CourseSkuListModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        if(self.model.data.count > 0) {
            [self.tableView reloadData];
        } else {
            [self.view showEmptyView:@"还没有课程，敬请期待哦！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,10,0,0);
}

#pragma mark - uitableview delegate & datasourse

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
    if (self.model == nil) {
        return 0;
    }
    return self.model.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DateSkuList * skuList = self.model.data[section];
    if (skuList.skus.count > 2 && !skuList.isShowMore) {
        return 4;
    }
    return 1 + skuList.skus.count;
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
    DateSkuList * skuList = self.model.data[indexPath.section];
    if(row == 0) {
        return 46;
    } else if (row == 3 && !skuList.isShowMore) {
        return 46;
    }
    return 82;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    DateSkuList * skuList = self.model.data[section];
    UITableViewCell * cell;
    if(row == 0) {
        BookSkuDateTitleCell *titleCell = [BookSkuDateTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierBookSkuDateTitleCell];
        [titleCell setData:skuList.date];
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (row == 3 && !skuList.isShowMore) {
        BookSkuMoreCell *moreCell = [BookSkuMoreCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierBookSkuMoreCell];
        cell = moreCell;
        
    } else {
        BookSkuItemCell *content = [BookSkuItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierBookSkuItemCell];
        [content setData:skuList.skus[row - 1]];
        cell = content;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.selectSection == section && self.selectRow == row) {
            cell.tintColor = MO_APP_ThemeColor;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (row == 0) {
        return;
    }
    
    DateSkuList * skuList = self.model.data[section];
    if(row == 3 && !skuList.isShowMore) {
        skuList.isShowMore = [NSNumber numberWithBool:YES];
        [tableView reloadData];
        return;
    }
    
    if (self.onlyShow) {
        return;
    }
    
    CourseSku *sku = skuList.skus[row - 1];
    if ([sku.stock intValue] <= 0) {
        return;
    }
    if (self.delegate) {
        [self.delegate onSkuSelect:sku inController:self];
        self.selectSection = section;
        self.selectRow = row;
        [tableView reloadData];
    }
}


@end
