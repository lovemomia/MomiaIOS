//
//  ArticleDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleDetailContentCell.h"
#import "ArticleDetailModel.h"
#import "ArticleCommentModel.h"
#import "ArticleDetailHeaderCell.h"
#import "ArticleDetailContentCell.h"
#import "ArticleDetailAuthorCell.h"
#import "ArticleDetailCommentCell.h"

@interface ArticleDetailViewController ()

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) ArticleDetailModel *model;

@property (nonatomic, strong) ArticleCommentModel * commentModel;

@property (nonatomic, assign)BOOL firstRequest;//评论的第一次请求


@end

@implementation ArticleDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.articleId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

//- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
//    return UITableViewCellSeparatorStyleSingleLine;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - requestWebData

//请求文章评论数据
-(void)requestCommentData {
//    if (self.commentModel == nil) {
//        [self.view showLoadingBee];
//    }
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/comment/article?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx&refid=1&start=0&count=4" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ArticleCommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (self.commentModel == nil) {
//            [self.view removeLoadingBee];
//        }
        
        self.commentModel = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//请求文章详情数据
- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/articledetail?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx&articleid=1" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ArticleDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}




#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return [ArticleDetailHeaderCell height]; //header
        
    } else if (row < [self.model.data.content count] + 1) {
        ArticleDetailContentItem *item = [self.model.data.content objectAtIndex:(row - 1)];
        return [ArticleDetailContentCell heightWithData:item]; //content
        
    } else if (row == [self.model.data.content count] + 1) {
        return [ArticleDetailAuthorCell height]; //author
        
    } else {
        
        if(self.commentModel) {
            
            if(row == self.model.data.content.count + self.commentModel.data.commentList.count + 2) {//在有了评论的时候弱到了最后一个，表明是加载更多评论标签
                return 40;
            } else {
                ArticleCommentItem * item = [self.commentModel.data.commentList objectAtIndex:(row - 2 - self.model.data.content.count)];
                return [ArticleDetailCommentCell heightWithData:item];
            }

        } else {
            return 40;
        }
        
    }
    
    return 116; //comment
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.model == nil) {
        return 0;
    }
    
    if(self.commentModel == nil) {//表明有model后，但是没有评论model，此时需要多加一个loading
        self.firstRequest = YES;
        return 3 + [self.model.data.content count];
    }
    //表明model和commentmodel都存在，可以全部显示
    return 3 + [self.model.data.content count] + [self.commentModel.data.commentList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    if (row == 0) {
        ArticleDetailHeaderCell *header = [ArticleDetailHeaderCell cellWithTableView:tableView];
        [header setData:self.model.data];
        cell = header;
        self.coverImageView = header.coverImageView;
        
    } else if (row < [self.model.data.content count] + 1) {
        //显示文章内容
        
        
        ArticleDetailContentItem *item = [self.model.data.content objectAtIndex:(row - 1)];
        
        ArticleDetailContentCell *content = [ArticleDetailContentCell cellWithTableView:tableView withData:item];

        [content setData:item];
        
        cell = content;
        
        
    } else if (row == [self.model.data.content count] + 1) {
        ArticleDetailAuthorCell *author = [ArticleDetailAuthorCell cellWithTableView:tableView];
        [author setData:self.model.data];
        cell = author;
        
        
    } else {//此处表明model的显示完全了，剩下的其他部分要显示，不包括加载更多评论
        if(self.commentModel) {
            
            if(row == self.model.data.content.count + self.commentModel.data.commentList.count + 2) {
                static NSString *moreIdentifier = @"CellMore";
                cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
                if (cell == nil) {
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
                    cell = [arr objectAtIndex:4];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            } else {
                
                ArticleCommentItem * item = [self.commentModel.data.commentList objectAtIndex:(row - 2 - self.model.data.content.count) ];
                ArticleDetailCommentCell * comment = [ArticleDetailCommentCell cellWithTableView:tableView];
                [comment setData:item];
                cell = comment;
            }
            
            
            
        } else {//表明不存在commentModel，要立马进行loading

            static NSString * loadIdentifier = @"CellLoading";
            cell = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
            }
            [cell showLoadingBee];
            if(self.firstRequest) {
                
                [self requestCommentData];
                self.firstRequest = NO;
            }
            
        }
        
        
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (self.coverImageView != nil) {
            self.coverImageView.top = offsetY;
            self.coverImageView.height = [ArticleDetailHeaderCell coverHeight] - offsetY;
        }
        self.navBackView.alpha = 0;
        
    } else if (offsetY > 200) {
        self.navBackView.alpha = 1;
        
    } else {
        self.navBackView.alpha = offsetY / 200;
    }
}

@end
