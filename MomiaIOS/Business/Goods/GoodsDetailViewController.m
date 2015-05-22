//
//  GoodsDetailViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailHeaderCell.h"

@interface GoodsDetailViewController ()

@property(nonatomic,strong) GoodsDetailModel * model;
@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation GoodsDetailViewController

//系统默认将嵌在navigation里的controller的view顶满整个视图，MOViewController里边将controller的view默认放到navigationbar下边，此处返回yes让其默认回到系统状态
- (BOOL)isNavTransparent {
    return YES;
}


-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        return [GoodsDetailHeaderCell height];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.01;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}



#pragma mark - tableview datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!self.model) return 0;
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else {
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell;
    if(section == 0) {
        GoodsDetailHeaderCell *header = [GoodsDetailHeaderCell cellWithTableView:tableView withData:self.model.data];
        self.coverImageView = header.photoImgView;
        cell = header;
    }
    return cell;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - request data
- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/goodsdetail?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx&goodsid=1" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[GoodsDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (self.coverImageView != nil) {
            self.coverImageView.top = offsetY;
            self.coverImageView.height = [GoodsDetailHeaderCell coverHeight] - offsetY;
        }
        self.navBackView.alpha = 0;
        
    } else if (offsetY > 200) {
        self.navBackView.alpha = 1;
        
    } else {
        self.navBackView.alpha = offsetY / 200;
    }
}

@end
