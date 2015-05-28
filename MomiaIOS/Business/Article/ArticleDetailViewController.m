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
#import "SubmitPostModel.h"

@interface ArticleDetailViewController ()

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) ArticleDetailModel *model;

@property (nonatomic, strong) CommentModel * commentModel;

@property (nonatomic, assign)BOOL firstRequest;//评论的第一次请求

@property (nonatomic, assign)BOOL upStatus;
@property (nonatomic, assign)int upNum;

@property (nonatomic, assign)BOOL favStatus;
@property (nonatomic, assign)int favNum;

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
#pragma mark - MOBarButtonItemViewDelegate
-(void)tapMOBarButtonItemView:(MOBarButtonItemView *)itemView
{
    if([[AccountService defaultService] isLogin]) {
        if(itemView.tag == 201501) {//点击点赞
            if(self.upStatus) {
                //取消点赞
                
                [itemView setUserInteractionEnabled:NO];
                NSDictionary * dic = @{@"articleid":@(self.model.data.articleId)};
                [[HttpService defaultService] POST:URL_APPEND_PATH(@"/article/praise/delete") parameters:dic JSONModelClass:[SubmitPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [itemView setUserInteractionEnabled:YES];
                    self.upStatus = NO;
                    self.upNum--;
                    NSString * upStr;
                    if(self.upNum >= 10000)
                        upStr = @"9999+";
                    else upStr = [NSString stringWithFormat:@"%d",self.upNum];
                    [itemView.contentLabel setText:upStr];
                    itemView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithContent:upStr], 44);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [itemView setUserInteractionEnabled:YES];
                    NSLog(@"error:%@",[error message]);
                    [AlertNotice showNotice:[error message]];
                }];

                
                
            } else {
                //开始点赞
                [itemView setUserInteractionEnabled:NO];
                NSDictionary * dic = @{@"articleid":@(self.model.data.articleId)};
                [[HttpService defaultService] POST:URL_APPEND_PATH(@"/article/praise/add") parameters:dic JSONModelClass:[SubmitPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [itemView setUserInteractionEnabled:YES];
                    self.upStatus = YES;
                    self.upNum++;
                    NSString * upStr;
                    if(self.upNum >= 10000)
                        upStr = @"9999+";
                    else upStr = [NSString stringWithFormat:@"%d",self.upNum];
                    //开始更新视图
//                    upStr = @"324";
                    [itemView.contentLabel setText:upStr];
                    itemView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithContent:upStr], 44);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [itemView setUserInteractionEnabled:YES];
                    NSLog(@"error:%@",[error message]);
                    [AlertNotice showNotice:[error message]];
                }];

                
                
            }
            
        } else if(itemView.tag == 201502){//点击收藏
            if(self.favStatus) {
                //取消收藏
                [itemView setUserInteractionEnabled:NO];
                NSDictionary * dic = @{@"type":@"0",@"refid":@(self.model.data.articleId)};
                [[HttpService defaultService] POST:URL_APPEND_PATH(@"/favorite/delete") parameters:dic JSONModelClass:[SubmitPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [itemView setUserInteractionEnabled:YES];
                    self.favStatus = NO;
                    self.favNum--;
                    NSString * favStr;
                    if(self.favNum >= 10000)
                        favStr = @"9999+";
                    else favStr = [NSString stringWithFormat:@"%d",self.favNum];
                    [itemView.contentLabel setText:favStr];
                    itemView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithContent:favStr], 44);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [itemView setUserInteractionEnabled:YES];
                    NSLog(@"error:%@",[error message]);
                    [AlertNotice showNotice:[error message]];
                }];
                
                
            } else {
                //添加收藏
                [itemView setUserInteractionEnabled:NO];
                NSDictionary * dic = @{@"type":@"0",@"title":self.model.data.title,@"refid":@(self.model.data.articleId)};
                [[HttpService defaultService] POST:URL_APPEND_PATH(@"/favorite/add") parameters:dic JSONModelClass:[SubmitPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //收藏成功
                    [itemView setUserInteractionEnabled:YES];
                    self.favStatus = YES;
                    self.favNum++;
                    NSString * favStr;
                    if(self.favNum >= 10000)
                        favStr = @"9999+";
                    else favStr = [NSString stringWithFormat:@"%d",self.favNum];
                    //开始更新视图
//                    favStr = @"9999+";
                    [itemView.contentLabel setText:favStr];
                    itemView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithContent:favStr], 44);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [itemView setUserInteractionEnabled:YES];
                    NSLog(@"error:%@",[error message]);
                    [AlertNotice showNotice:[error message]];
                }];
                
            }
            
        }
        
    } else {
        [[AccountService defaultService] login:self];
    }
    
}

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
        NSLog(@"success:%@",responseObject);
        [self setUpNav];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - navigationBarItem

-(void)setUpNav
{
    MOBarButtonItemView * upView = [[MOBarButtonItemView alloc] init];
    upView.tag = 201501;
    [upView.contentLabel setText:[NSString stringWithFormat:@"%d",self.model.data.upNum]];
    
    self.upStatus = self.model.data.upStatus;
    self.upNum = self.model.data.upNum;
    self.favStatus = self.model.data.favStatus;
    self.favNum = self.model.data.favNum;
    [upView.iconImgView setImage:[UIImage imageNamed:@"nav_up"]];
    upView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithArticleData:self.model.data withContentStyle:ContentStyleUp], 44);
    [upView setDelegate:self];
    
    MOBarButtonItemView * favView = [[MOBarButtonItemView alloc] init];
    favView.tag = 201502;
    [favView.contentLabel setText:[NSString stringWithFormat:@"%d",self.model.data.favNum]];
    [favView.iconImgView setImage:[UIImage imageNamed:@"nav_fav"]];
    favView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithArticleData:self.model.data withContentStyle:ContentStyleFavourite], 44);
    [favView setDelegate:self];
    
    UIBarButtonItem * upItem = [[UIBarButtonItem alloc] initWithCustomView:upView];
    UIBarButtonItem * favItem = [[UIBarButtonItem alloc] initWithCustomView:favView];
    self.navigationItem.rightBarButtonItems = @[favItem,upItem];
    
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
