//
//  PlaymateDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedTitleCell.h"
#import "MyFavCell.h"
#import "FeedUserHeadCell.h"
#import "FeedContentCell.h"
#import "FeedZanCell.h"
#import "FeedMoreCell.h"
#import "FeedCommentCell.h"
#import "FeedDetailModel.h"
#import "MJRefresh.h"
#import "AddCommentViewController.h"
#import "MONavigationController.h"
#import "MJRefreshHelper.h"

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierFeedZanCell = @"FeedZanCell";
static NSString *identifierMyFavCell = @"MyFavCell";
static NSString *identifierFeedTitleCell = @"FeedTitleCell";
static NSString *identifierFeedMoreCell = @"FeedMoreCell";
static NSString *identifierFeedCommentCell = @"FeedCommentCell";

@interface FeedDetailViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) FeedDetailModel *model;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation FeedDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"详情";
    
    [FeedUserHeadCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [FeedZanCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierFeedZanCell];
    [FeedTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierFeedTitleCell];
    [MyFavCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierMyFavCell];
    [FeedMoreCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierFeedMoreCell];
    [FeedCommentCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierFeedCommentCell];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self.commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
    [self.zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10, 0.0, 0.0)];
    
    [self requestData];
}

- (void)requestData {
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }

    NSDictionary * dic = @{@"id":self.ids};
    self.curOperation = [[HttpService defaultService] GET:URL_APPEND_PATH(@"/feed/detail") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[FeedDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        if ([self.model.data.feed.stared boolValue]) {
            self.zanBtn.imageView.image = [UIImage imageNamed:@"IconZanRed"];
        } else {
            self.zanBtn.imageView.image = [UIImage imageNamed:@"IconZan"];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
        [self.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UIEdgeInsetsMake(0,65,0,0);
    }
    return UIEdgeInsetsMake(0,10,0,0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model == nil) {
        return 0;
    }
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        //活动详情
        [self openURL:[NSString stringWithFormat:@"duola://coursedetail?id=%@", self.model.data.course.ids]];
    } else if (indexPath.section == 2 && indexPath.row == 4) {
        //查看更多评论
        [self openURL:[NSString stringWithFormat:@"duola://commentlist?id=%@", self.ids]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        FeedStarList *starUsers = self.model.data.staredUsers;
        if (starUsers && starUsers.list && starUsers.list.count > 0) {
            return 3;
        }
        return 2;
    } else if (section == 1) {
        return 2;
    }
    FeedCommentList *comments = self.model.data.comments;
    if (comments.list.count >= 3) {
        return 5;
    }
    if (comments.list.count == 0) {
        return 2; //还没有人评论，快来抢沙发哟~
    }
    return comments.list.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [FeedUserHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateUserHeadCell forIndexPath:indexPath data:self.model.data.feed];
        } else if (indexPath.row == 1) {
            return [FeedContentCell heightWithTableView:tableView contentModel:self.model.data.feed];
        } else {
            return [FeedZanCell heightWithTableView:tableView withIdentifier:identifierFeedZanCell forIndexPath:indexPath data:nil];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [FeedTitleCell heightWithTableView:tableView withIdentifier:identifierFeedTitleCell forIndexPath:indexPath data:@"相关活动"];
        } else {
//            return [MyFavCell heightWithTableView:tableView withIdentifier:identifierMyFavCell forIndexPath:indexPath data:nil];
            return 87;
        }
        
    } else {
        if (indexPath.row == 0) {
            return [FeedTitleCell heightWithTableView:tableView withIdentifier:identifierFeedTitleCell forIndexPath:indexPath data:@"最新评论"];
        } else if (indexPath.row == 4) {
            return [FeedMoreCell heightWithTableView:tableView withIdentifier:identifierFeedMoreCell forIndexPath:indexPath data:@"查看更多评论"];
        } else {
            if (self.model.data.comments.list.count == 0) {
                return 110;
            }
            FeedComment *comment = [self.model.data.comments.list objectAtIndex:(indexPath.row - 1)];
            return [FeedCommentCell heightWithTableView:tableView withIdentifier:identifierFeedCommentCell forIndexPath:indexPath data:comment];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 60;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FeedUserHeadCell * userHead = [FeedUserHeadCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUserHeadCell];
            [userHead setData:self.model.data.feed];
            cell = userHead;
            
        } else if (indexPath.row == 1) {
            cell = [[FeedContentCell alloc]initWithTableView:tableView contentModel:self.model.data.feed];
            
        } else {
            __weak FeedZanCell *zanCell = [FeedZanCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedZanCell];
            [zanCell setData:self.model.data.staredUsers];
            if ([self.model.data.feed.stared boolValue]) {
                zanCell.zanIcon.image = [UIImage imageNamed:@"IconZanRed"];
            } else {
                zanCell.zanIcon.image = [UIImage imageNamed:@"IconZan"];
            }
            zanCell.blockOnZanClicked = ^(){
                if (![[AccountService defaultService] isLogin]) {
                    [[AccountService defaultService] login:self];
                }
                Feed *feed = self.model.data.feed;
                NSDictionary * dic = @{@"id":feed.ids};
                BOOL isStared = [feed.stared boolValue];
                NSString *path = isStared ? @"/feed/unstar" : @"/feed/star";
                [[HttpService defaultService] POST:URL_APPEND_PATH(path) parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestData:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
//                NSDictionary * dic = @{@"id":self.model.data.feed.ids};
//                [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feed/star") parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.model.data.staredUsers.list];
//                    FeedStar *me = [[FeedStar alloc]init];
//                    me.nickName = [[AccountService defaultService] account].nickName;
//                    me.avatar = [[AccountService defaultService] account].avatar;
//                    [array insertObject:me atIndex:0];
//                    self.model.data.staredUsers.list = (NSArray<FeedStar> *)array;
//                    self.model.data.staredUsers.totalCount = [NSNumber numberWithInt:self.model.data.staredUsers.totalCount.intValue + 1];
//                    [zanCell setData:self.model.data.staredUsers];
//                    
//                    self.model.data.feed.stared = [NSNumber numberWithBool:YES];
//                    self.model.data.feed.starCount = [NSNumber numberWithInt:([self.model.data.feed.starCount intValue] + 1)];
//                    [self.tableView reloadData];
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
            };
            cell = zanCell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FeedTitleCell *titleCell = [FeedTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedTitleCell];
            titleCell.data = @"相关活动";
            cell = titleCell;
            
        } else {
            MyFavCell *productCell = [MyFavCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierMyFavCell];
            [productCell setData:self.model.data.course];
            cell = productCell;
        }
        
    } else {
        if (indexPath.row == 0) {
            FeedTitleCell *titleCell = [FeedTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedTitleCell];
            titleCell.data = @"最新评论";
            cell = titleCell;
            
        } else if (indexPath.row == 4) {
            cell = [FeedMoreCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedMoreCell];
            
        } else {
            if (self.model.data.comments.list.count == 0) {
                FeedMoreCell *infoCell = [FeedMoreCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedMoreCell];
                [infoCell setData:@"还没有人评论，快来抢沙发哟~"];
                cell = infoCell;
                
            } else {
                FeedComment *comment = [self.model.data.comments.list objectAtIndex:(indexPath.row - 1)];
                FeedCommentCell *commentCell = [FeedCommentCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedCommentCell];
                commentCell.data = comment;
                cell = commentCell;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)onCommentClicked:(id)sender {
    NSDictionary * dic = @{@"id":self.ids};
    AddCommentViewController *controller = [[AddCommentViewController alloc]initWithParams:dic];
    
    controller.successBlock = ^(){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self requestData];
    };
    controller.cancelBlock = ^(){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)onZanClicked:(id)sender {
    if (![[AccountService defaultService] isLogin]) {
        [[AccountService defaultService] login:self];
    }
    
//    NSDictionary * dic = @{@"id":self.model.data.feed.ids};
//    [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feed/star") parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.model.data.staredUsers.list];
//        FeedStar *me = [[FeedStar alloc]init];
//        me.nickName = [[AccountService defaultService] account].nickName;
//        me.avatar = [[AccountService defaultService] account].avatar;
//        [array insertObject:me atIndex:0];
//        self.model.data.staredUsers.list = (NSArray<FeedStar> *)array;
//        self.model.data.staredUsers.totalCount = [NSNumber numberWithInt:self.model.data.staredUsers.totalCount.intValue + 1];
//        self.model.data.feed.stared = [NSNumber numberWithBool:YES];
//        self.model.data.feed.starCount = [NSNumber numberWithInt:([self.model.data.feed.starCount intValue] + 1)];
//        [self.tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    Feed *feed = self.model.data.feed;
    NSDictionary * dic = @{@"id":feed.ids};
    BOOL isStared = [feed.stared boolValue];
    NSString *path = isStared ? @"/feed/unstar" : @"/feed/star";
    [[HttpService defaultService] POST:URL_APPEND_PATH(path) parameters:dic JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestData:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
