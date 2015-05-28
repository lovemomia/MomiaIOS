//
//  CommentViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "SendCommentView.h"
#import "CommentPostModel.h"
#define pageSize 10

@interface CommentViewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) CommentModel * commentModel;
@property (nonatomic, strong) SendCommentView * sendCommentView;
@property (nonatomic, assign) NSInteger idByType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger currentPage;//表示当前页，缺省为0

@property (nonatomic, assign) BOOL continueLoading;//控制request请求在执行的期间只执行一次，缺省为NO

@property (nonatomic, assign) BOOL isRefresh;


@end

@implementation CommentViewController


///* tableView分割线，默认无 */
//- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
//{
//    return UITableViewCellSeparatorStyleSingleLine;
//}

-(SendCommentView *)sendCommentView
{
    if(_sendCommentView == nil) {
        _sendCommentView = [[SendCommentView alloc] init];
    }
    return _sendCommentView;
}

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - life cycle

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.idByType = [[params objectForKey:@"id"] integerValue];
        self.type = [[params objectForKey:@"type"] integerValue];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:MO_APP_VCBackgroundColor];
    self.navigationItem.title = @"评论";
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    //当单元格数目少于屏幕时会出现多余分割线，直接设置tableFooterView用以删除
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.sendCommentView];
    
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@50);
    }];
    [self.sendCommentView setBackgroundColor:[UIColor whiteColor]];
    
    __weak CommentViewController * weakSelf = self;
    
    [self.sendCommentView set_sentCommentBlock:^(UIButton *sender, UITextField *textContentView) {
        if([[textContentView text] isEqualToString:@""]) {
            [AlertNotice showNotice:@"评论不能为空"];
        } else if([[textContentView text] length] > 200) {
            [AlertNotice showNotice:@"评论不能超过200字符"];
        } else {
            //开始发送
            NSDictionary * dic = @{@"type":@(weakSelf.type),@"content":textContentView.text,@"refid":@(weakSelf.idByType)};
            
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.sendCommentView setUserInteractionEnabled:NO];
            
            
            
            [[HttpService defaultService] POST:URL_APPEND_PATH(@"/comment") parameters:dic JSONModelClass:[CommentPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                CommentPostModel * result = responseObject;
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.sendCommentView setUserInteractionEnabled:YES];
                [textContentView resignFirstResponder];
                
                
                if(result.errNo == 0) {//发送成功
                    weakSelf.isRefresh = YES;
                    [weakSelf requestData];
                }
                else {
                    NSLog(@"%d",result.errNo);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.sendCommentView setUserInteractionEnabled:YES];
                
                [textContentView resignFirstResponder];
                
                
                NSLog(@"error:%@",[error localizedDescription]);
            }];
        }
    }];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf requestData];
    }];
    
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
    
    if(self.isRefresh) {//表明是发送成功后的请求
        self.isRefresh = NO;
        [self.dataArray removeAllObjects];
        self.currentPage = 0;
        [self.tableView reloadData];
    }
    
    self.continueLoading = NO;
    
    if (self.commentModel == nil) {
        [self.view showLoadingBee];
    }
    NSDictionary * paramDic;
    NSString * urlStr;
    if(self.type == 0) {//style == 1表示为文章评论
        urlStr = URL_APPEND_PATH(@"/comment/article");
        paramDic = @{@"articleid":@(self.idByType),@"start":@(self.currentPage++ * pageSize),@"count":@(pageSize)};
    } else {
        urlStr = URL_APPEND_PATH(@"/comment/goods");
        paramDic = @{@"goodsid":@(self.idByType),@"start":@(self.currentPage++ * pageSize),@"count":@(pageSize)};
    }

    [[HttpService defaultService] GET:urlStr parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.commentModel == nil) {
            [self.view removeLoadingBee];
        }
        
        self.continueLoading = YES;
        
        self.commentModel = responseObject;
        
        [self.dataArray addObjectsFromArray:self.commentModel.data.commentList];
        
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}




#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row == self.dataArray.count) {
        return 44.0f;
    }
    CommentItem * item = [self.dataArray objectAtIndex:indexPath.row];
    return [CommentCell heightWithData:item];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataArray.count&&self.dataArray.count >= self.currentPage * pageSize)
        return self.dataArray.count + 1;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.dataArray.count) {
        static NSString * loadIdentifier = @"CellCommentLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(self.continueLoading) {
            [self requestData];
        }
    } else {
        CommentItem * item = [self.dataArray objectAtIndex:indexPath.row];
        CommentCell * comment = [CommentCell cellWithTableView:tableView];
        [comment setData:item];
        cell = comment;
    }
    return cell;
}



@end

