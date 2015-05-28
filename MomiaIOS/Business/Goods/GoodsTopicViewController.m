//
//  GoodsTopicViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsTopicViewController.h"
#import "GoodsTopicModel.h"
#import "GoodsTopicHeaderCell.h"
#import "GoodsTopicItemCell.h"


@interface GoodsTopicViewController ()

@property(nonatomic,strong) GoodsTopicModel * model;
@property (nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic,assign) NSInteger topicId;

@end

@implementation GoodsTopicViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.topicId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}

/* tableView分割线，默认无 */
//- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
//{
//    return UITableViewCellSeparatorStyleSingleLine;
//}


//系统默认将嵌在navigation里的controller的view顶满整个视图，MOViewController里边将controller的view默认放到navigationbar下边，此处返回yes让其默认回到系统状态
- (BOOL)isNavTransparent {
    return YES;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addHeaderMaskView];
    [self addNavBackView];
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
    
     NSDictionary * dic = @{@"topicid":@(self.topicId)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/goodstopic") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[GoodsTopicModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
//        [self initNavBackView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
//    if (indexPath.row == 0) {
//        return;
//    }
//    
//    if (self.model) {
//        ArticleTopicItem *data = [self.model.data.list objectAtIndex:indexPath.row - 1];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"momia://articledetail?id=%d", data.articleId]];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    GoodsTopicItem * data = self.model.data.list[indexPath.row - 1];
    
    NSString * urlStr = [NSString stringWithFormat:@"momia://goodsdetail?id=%d",data.goodsId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication ] openURL:url];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        GoodsTopicHeaderCell *header = [GoodsTopicHeaderCell cellWithTableView:tableView withData:self.model.data];
        self.coverImageView = header.photoImgView;
        cell = header;
        cell.backgroundColor = MO_APP_VCBackgroundColor;
        
    } else {
        GoodsTopicItemCell *item = [GoodsTopicItemCell cellWithTableView:tableView withData:[self.model.data.list objectAtIndex:indexPath.row - 1]];
        cell = item;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [GoodsTopicHeaderCell heightWithData:self.model.data];
    }
    return [GoodsTopicItemCell height];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (self.coverImageView != nil) {
            self.coverImageView.top = offsetY;
            self.coverImageView.height = [GoodsTopicHeaderCell coverHeight] - offsetY;
        }
        self.navBackView.alpha = 0;
        
    } else if (offsetY > 200) {
        self.navBackView.alpha = 1;
        
    } else {
        self.navBackView.alpha = offsetY / 200;
    }
}



@end
