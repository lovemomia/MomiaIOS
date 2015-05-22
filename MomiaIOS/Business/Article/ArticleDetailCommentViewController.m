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
#import "SendCommentView.h"
#import "Masonry.h"
#import "ArticleCommentPostModel.h"

@interface ArticleDetailCommentViewController ()

@property (nonatomic, strong) ArticleCommentModel * commentModel;
@property (nonatomic, strong) SendCommentView * sendCommentView;

@end

@implementation ArticleDetailCommentViewController


/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(SendCommentView *)sendCommentView
{
    if(_sendCommentView == nil) {
        _sendCommentView = [[SendCommentView alloc] init];
    }
    return _sendCommentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:MO_APP_VCBackgroundColor];
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
    
    __weak ArticleDetailCommentViewController * weakSelf = self;
    
    [self.sendCommentView set_sentCommentBlock:^(UIButton *sender, UITextField *textContentView) {
        if([[textContentView text] isEqualToString:@""]) {
            [AlertNotice showNotice:@"评论不能为空"];
        } else if([[textContentView text] length] > 200) {
            [AlertNotice showNotice:@"评论不能超过200字符"];
        } else {
            //开始发送
            NSDictionary * dic = @{@"type":@"0",@"content":textContentView.text,@"refid":@"1"};

            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.sendCommentView setUserInteractionEnabled:NO];
            
            [[HttpService defaultService] POST:@"http://i.momia.cn/comment" parameters:dic JSONModelClass:[ArticleCommentPostModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                ArticleCommentPostModel * result = [[ArticleCommentPostModel alloc] initWithDictionary:responseObject error:nil];
                
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.sendCommentView setUserInteractionEnabled:YES];
                [textContentView resignFirstResponder];
                
                
                if(result.errNo == 0) {
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
    
    [[HttpService defaultService] GET:@"http://120.55.102.12:8080/comment/article?v=1.0&teminal=iphone&os=8.0&device=iphone6&channel=xxx&net=3g&sign=xxxx&refid=1&start=0&count=10" parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ArticleCommentModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    comment.backgroundColor = MO_APP_VCBackgroundColor;
    return comment;
}



@end
