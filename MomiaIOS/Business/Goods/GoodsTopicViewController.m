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
#import "SubmitPostModel.h"

@interface GoodsTopicViewController ()

@property(nonatomic,strong) GoodsTopicModel * model;
@property (nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic,assign) NSInteger topicId;

@property (nonatomic, assign)BOOL favStatus;
@property (nonatomic, assign)int favNum;

@end

@implementation GoodsTopicViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.topicId = [[params objectForKey:@"id"] integerValue];
    }
    return self;
}

/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}


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

#pragma mark - MOBarButtonItemViewDelegate
-(void)tapMOBarButtonItemView:(MOBarButtonItemView *)itemView
{
    if([[AccountService defaultService] isLogin]) {
        
        if(self.favStatus) {
            //取消收藏
            [itemView setUserInteractionEnabled:NO];
            NSDictionary * dic = @{@"type":@"3",@"refid":@(self.model.data.topicId)};
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
            NSDictionary * dic = @{@"type":@"3",@"title":self.model.data.topicTitle,@"refid":@(self.model.data.topicId)};
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
        
        
    } else {
        [[AccountService defaultService] login:self];
    }
    
}


#pragma mark - navigationBarItem

-(void)setUpNav
{
    self.favStatus = self.model.data.favStatus;
    self.favNum = self.model.data.favNum;
    
    MOBarButtonItemView * favView = [[MOBarButtonItemView alloc] init];
    [favView.contentLabel setText:[NSString stringWithFormat:@"%d",self.model.data.favNum]];
    [favView.iconImgView setImage:[UIImage imageNamed:@"nav_fav"]];
    favView.frame = CGRectMake(0, 0, [MOBarButtonItemView widthWithGoodsTopicData:self.model.data], 44);
    [favView setDelegate:self];
    
    UIBarButtonItem * favItem = [[UIBarButtonItem alloc] initWithCustomView:favView];
    self.navigationItem.rightBarButtonItems = @[favItem];
    
}




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
        [self setUpNav];

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
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tq://articledetail?id=%d", data.articleId]];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    GoodsTopicItem * data = self.model.data.list[indexPath.row - 1];
    
    NSString * urlStr = [NSString stringWithFormat:@"tq://goodsdetail?id=%d",data.goodsId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication ] openURL:url];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
