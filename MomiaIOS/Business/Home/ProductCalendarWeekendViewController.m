//
//  ProductCalendarWeekendViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarWeekendViewController.h"
#import "ProductCalendarCell.h"
#import "ProductCalendarModel.h"

static NSString * productCalendarWeekendIdentifier = @"CellProductCalendarWeekend";

@interface ProductCalendarWeekendViewController ()

@property(nonatomic,strong) ProductCalendarModel * model;
@property(nonatomic,strong) NSMutableArray * array;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) BOOL isLoading;


@end

@implementation ProductCalendarWeekendViewController

-(NSMutableArray *)array {
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

-(UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.model.data.list.count > 0)
        return self.array.count + 1;
    else return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger row = indexPath.row;
    if(row < self.array.count) {
        ProductCalendarCell * content = [ProductCalendarCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarWeekendIdentifier];
        [content setData:self.array[row]];
        cell = content;
    } else {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData];
            self.isLoading = YES;
        }

    }
    
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(row < self.array.count) {
        ProductModel * model = self.array[row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://productdetail?id=%ld", (long)model.pID]];
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"city":@1,@"start":@(self.index)};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product/weekend") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[ProductCalendarModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        [self.array addObjectsFromArray:self.model.data.list];
        
        if(self.model.data.nextIndex) {
            self.index = self.model.data.nextIndex.integerValue;
        } else {
            self.model = nil;
        }
        

        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ProductCalendarCell registerCellWithTableView:self.tableView withIdentifier:productCalendarWeekendIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
