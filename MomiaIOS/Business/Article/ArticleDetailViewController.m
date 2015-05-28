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
#import "CommentModel.h"
#import "ArticleDetailHeaderCell.h"
#import "ArticleDetailContentCell.h"
#import "ArticleDetailAuthorCell.h"
#import "ArticleDetailConstantCell.h"
#import "CommentCell.h"
#import "MOBarButtonItemView.h"

@interface ArticleDetailViewController ()

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) ArticleDetailModel *model;

@property (nonatomic, strong) CommentModel * commentModel;

@property (nonatomic, assign)BOOL firstRequest;//评论的第一次请求


@end

@implementation ArticleDetailViewController

#pragma mark - alter default settings

- (BOOL)isNavTransparent {
    return YES;
}


-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

//- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
//    return UITableViewCellSeparatorStyleSingleLine;
//}


#pragma mark - life cycle

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.articleId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addHeaderMaskView];
    [self addNavBackView];
    
    
    
    MOBarButtonItemView * collectionView = [[MOBarButtonItemView alloc] init];
    
    collectionView.iconImgView.image = [UIImage imageNamed:@"UserHeaderButtonFavorites"];
    collectionView.contentLabel.text = @"5677";
    
    collectionView.frame = CGRectMake(0, 0, 80, 44);
   
    UIBarButtonItem * collectionItem = [[UIBarButtonItem alloc] initWithCustomView:collectionView];
    
    self.navigationItem.rightBarButtonItems = @[collectionItem];
    

    // 请求数据
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

#pragma mark - requestWebData

//请求评论数据
-(void)requestCommentData {
    NSDictionary * dic = @{@"articleid":@(self.articleId), @"start":@"0", @"count":@"3"};
    

    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/comment/article") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[CommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSDictionary * dic = @{@"articleid":@(self.articleId)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/articledetail") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[ArticleDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}




#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 3) {
        if(row == 0) {//跳转到评论页面
            NSString * urlStr = [NSString stringWithFormat:@"momia://comment?id=%ld&type=0",(long)self.articleId];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication ] openURL:url];
            
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        return [ArticleDetailHeaderCell height];
    } else if(section == 1) {
        if(row == self.model.data.content.count) {
            return [ArticleDetailConstantCell height];
        } else {
            return [ArticleDetailContentCell heightWithData:self.model.data.content[row]];
        }
        
    } else if(section == 2) {
        return [ArticleDetailAuthorCell height];
    } else if(section == 3) {
        if(row == 0) {
            return 44.0f;
        } else {
            return [CommentCell heightWithData:self.commentModel.data.commentList[row - 1]];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.01;
    } else if(section == 1) {
        return 1;
    } else if(section == 2) {
        return 1;
    } else if(section == 3) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0) {
        return 0.01;
    } else if(section == 1) {
        return 0.01;
    } else if(section == 2) {
        return 5;
    }
    return 0;
}


#pragma mark - tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model == nil) return 0;
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return self.model.data.content.count +1;
    } else if(section == 2) {
        return 1;
    } else if(section == 3) {
        if(self.commentModel == nil) {
            self.firstRequest = YES;
            return 2;//多了一个loading视图
        } else {
            return self.commentModel.data.commentList.count + 1;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        ArticleDetailHeaderCell *header = [ArticleDetailHeaderCell cellWithTableView:tableView];
        header.data = self.model.data;
        self.coverImageView = header.coverImageView;
        cell = header;
    } else if(section == 1) {
        if(row == self.model.data.content.count) {
            ArticleDetailConstantCell * constant = [ArticleDetailConstantCell cellWithTableView:tableView];
            cell = constant;
        } else {
            ArticleDetailContentCell * content = [ArticleDetailContentCell cellWithTableView:tableView withData:self.model.data.content[row]];
            cell = content;
        }
        
    } else if(section == 2){
        ArticleDetailAuthorCell * content = [ArticleDetailAuthorCell cellWithTableView:tableView];
        content.data = self.model.data;
        cell = content;
    } else if(section == 3) {
        if(row == 0) {
            static NSString * titleIdentifier = @"CellArticleDetailCommentTitle";
            UITableViewCell * value1 = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if(value1 == nil) {
                value1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleIdentifier];
                value1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                value1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            value1.textLabel.text = @"麻麻说";
            value1.detailTextLabel.text = @"更多评论";
            value1.backgroundColor = [UIColor whiteColor];
            cell = value1;
            
        } else {
            if(self.commentModel) {//表明有评论
                CommentItem * item = [self.commentModel.data.commentList objectAtIndex:row - 1];
                CommentCell * comment = [CommentCell cellWithTableView:tableView];
                [comment setData:item];
                cell = comment;
                
            } else {//表明还未开始刷评论数据
                static NSString * loadIdentifier = @"CellArticleDetailCommentLoading";
                UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
                if(load == nil) {
                    load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
                }
                [load showLoadingBee];
                cell = load;
                
                if(self.firstRequest) {
                    [self requestCommentData];
                    self.firstRequest = NO;
                }
                
            }
        }
    }


    return cell;
}

#pragma mark - uiscrollview delegate

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
