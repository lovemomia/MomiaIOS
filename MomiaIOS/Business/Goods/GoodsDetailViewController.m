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
#import "GoodsDetailImgCell.h"
#import "GoodsDetailContentCell.h"
#import "GoodsDetailShopCell.h"
#import "CommentModel.h"
#import "CommentCell.h"

#define shopStr @"您可以通过以下方式购买"

@interface GoodsDetailViewController ()

@property(nonatomic,strong) GoodsDetailModel * model;
@property (nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic,strong) CommentModel * commentModel;
@property (nonatomic, assign)BOOL firstRequest;//评论的第一次请求

@property (nonatomic,assign) NSInteger goodsId;


@end

@implementation GoodsDetailViewController

#pragma mark - alter tableview settings

//系统默认将嵌在navigation里的controller的view顶满整个视图，MOViewController里边将controller的view默认放到navigationbar下边，此处返回yes让其默认回到系统状态
- (BOOL)isNavTransparent {
    return YES;
}


-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}


#pragma mark - ViewController cycle

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

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.goodsId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}


#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 3) {
        if(row == 0) {//跳转到评论页面
            NSString * urlStr = [NSString stringWithFormat:@"momia://comment?id=%ld&type=1",self.goodsId];
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
        return [GoodsDetailHeaderCell height];
    } else if(section == 1) {
        if(row == 0) {
            return [GoodsDetailContentCell heightWithData:self.model.data];
        } else {
            return [GoodsDetailImgCell heightWithData:self.model.data.imgs[row - 1]];
        }
        
    } else if(section == 2) {
        if(row == 0) {
            return [GoodsDetailContentCell heightWithString:shopStr];
        } else {
            return [GoodsDetailShopCell heightWithData:self.model.data.shopList[row - 1]];
        }
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
        return 5;
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
        return 5;
    } else if(section == 2) {
        return 5;
    }
    return 0;
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
    } else if(section == 1) {
        return self.model.data.imgs.count + 1;
    } else if(section == 2) {
        return self.model.data.shopList.count + 1;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell;
    if(section == 0) {
        GoodsDetailHeaderCell *header = [GoodsDetailHeaderCell cellWithTableView:tableView withData:self.model.data];
        self.coverImageView = header.photoImgView;
        cell = header;
    } else if(section == 1) {
        if(row == 0) {
            GoodsDetailContentCell * content = [GoodsDetailContentCell cellWithTableView:tableView withData:self.model.data];
            cell = content;
        } else {
            GoodsDetailImgCell * img = [GoodsDetailImgCell cellWithTableView:tableView withData:[self.model.data.imgs objectAtIndex:row - 1]];
            cell = img;
        }
        
    } else if(section == 2){
        if(row == 0) {
            GoodsDetailContentCell * content = [GoodsDetailContentCell cellWithTableView:tableView withString:shopStr];
            cell = content;
        } else {
            GoodsDetailShopCell * shop = [GoodsDetailShopCell cellWithTableView:tableView withData:self.model.data.shopList[row - 1]];
            cell = shop;
        }
    } else if(section == 3) {
        if(row == 0) {
            static NSString * titleIdentifier = @"CellGoodsDetailCommentTitle";
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
                static NSString * loadIdentifier = @"CellGoodsDetailCommentLoading";
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



#pragma mark - request data

//请求评论数据
-(void)requestCommentData {
    NSDictionary * dic = @{@"goodsid":@(self.goodsId), @"start":@"0", @"count":@"3"};
    
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/comment/goods") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[CommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        if (self.commentModel == nil) {
        //            [self.view removeLoadingBee];
        //        }
        
        self.commentModel = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
     NSDictionary * dic = @{@"goodsid":@(self.goodsId)};
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/goodsdetail") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[GoodsDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - UIScrollView Delegate
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
