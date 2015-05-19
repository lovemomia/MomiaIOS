//
//  ArticleDetailCommentViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailCommentViewController.h"
#import "ArticleCommentModel.h"
#import "ArticleDetailCommentCell.h"


@interface ArticleDetailCommentViewController ()

@property (nonatomic, strong) ArticleCommentModel * commentModel;

@end

@implementation ArticleDetailCommentViewController


/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"评论";
   //预留30的高度给发表评论使用
    CGRect rc = self.tableView.frame;
    rc.size.height -= 30;
    self.tableView.frame = rc;
    
    
    //当单元格数目少于屏幕时会出现多余分割线，直接设置tableFooterView用以删除
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

#pragma mark - requestData
//请求评论详情数据
- (void)requestData {
    if (self.commentModel == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/comment/article?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx&refid=1&start=0&count=4" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ArticleCommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.commentModel == nil) {
            [self.view removeLoadingBee];
        }
        
        self.commentModel = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}




#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleCommentItem * item = [self.commentModel.data.commentList objectAtIndex:indexPath.row];
    return [ArticleDetailCommentCell heightWithData:item];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentModel.data.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCommentItem * item = [self.commentModel.data.commentList objectAtIndex:indexPath.row];
    ArticleDetailCommentCell * comment = [ArticleDetailCommentCell cellWithTableView:tableView];
    [comment setData:item];
    return comment;
}



@end
