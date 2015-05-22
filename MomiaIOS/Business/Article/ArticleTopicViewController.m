//
//  ArticleListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleTopicViewController.h"
#import "ArticleTopicModel.h"
#import "ArticleTopicHeaderCell.h"
#import "ArticleTopicItemCell.h"

@interface ArticleTopicViewController ()

@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, strong) ArticleTopicModel *model;
@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation ArticleTopicViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.topicId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addNavBackView];
    
    // 请求数据
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNavTransparent {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"topicid":@(self.topicId)};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/articletopic") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[ArticleTopicModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        [self initNavBackView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)initNavBackView {
    
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.model == nil) {
        return 0;
    }
    return [self.model.data.list count] + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
    if (self.model) {
        ArticleTopicItem *data = [self.model.data.list objectAtIndex:indexPath.row - 1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://articledetail?id=%d", data.articleId]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        ArticleTopicHeaderCell *header = [ArticleTopicHeaderCell cellWithTableView:tableView];
        [header setData:self.model.data];
        self.coverImageView = header.coverIv;
        cell = header;
        
    } else {
        ArticleTopicItemCell *item = [ArticleTopicItemCell cellWithTableView:tableView];
        ArticleTopicItem *data = [self.model.data.list objectAtIndex:indexPath.row - 1];
        [item setData:data];
        cell = item;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [ArticleTopicHeaderCell height];
    }
    return [ArticleTopicItemCell height];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (self.coverImageView != nil) {
            self.coverImageView.top = offsetY;
            self.coverImageView.height = [ArticleTopicHeaderCell coverHeight] - offsetY;
        }
        self.navBackView.alpha = 0;
        
    } else if (offsetY > 200) {
        self.navBackView.alpha = 1;
        
    } else {
        self.navBackView.alpha = offsetY / 200;
    }
}

@end
