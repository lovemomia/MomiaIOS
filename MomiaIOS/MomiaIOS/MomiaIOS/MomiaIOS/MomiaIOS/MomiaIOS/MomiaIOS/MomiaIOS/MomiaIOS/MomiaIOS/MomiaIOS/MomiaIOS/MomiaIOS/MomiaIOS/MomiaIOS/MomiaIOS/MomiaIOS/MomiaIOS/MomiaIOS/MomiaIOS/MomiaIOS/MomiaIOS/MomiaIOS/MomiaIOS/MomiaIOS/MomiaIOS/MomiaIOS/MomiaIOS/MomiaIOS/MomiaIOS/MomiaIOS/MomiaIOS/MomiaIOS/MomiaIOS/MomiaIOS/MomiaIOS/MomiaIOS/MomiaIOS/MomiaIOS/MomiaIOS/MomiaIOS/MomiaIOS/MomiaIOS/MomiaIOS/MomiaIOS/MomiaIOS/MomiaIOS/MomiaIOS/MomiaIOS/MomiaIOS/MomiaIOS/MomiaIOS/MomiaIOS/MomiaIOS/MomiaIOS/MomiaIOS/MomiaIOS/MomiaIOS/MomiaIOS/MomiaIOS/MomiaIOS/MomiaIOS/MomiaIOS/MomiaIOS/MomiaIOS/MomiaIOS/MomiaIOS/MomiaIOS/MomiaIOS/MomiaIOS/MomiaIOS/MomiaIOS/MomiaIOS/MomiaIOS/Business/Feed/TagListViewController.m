//
//  TagListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/9.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "TagListViewController.h"

#import "CommonHeaderView.h"

@interface TagListViewController ()
@property (nonatomic, strong) FeedTagListModel * model;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;
@end

@implementation TagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择标签";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"TitleCancel"]];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(onAddClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    
    [self requestData];
}

- (void)onCancelClicked {
    [self.delegate onCancel];
}

- (void)onAddClicked {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"新增标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { //修改昵称
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        
        FeedTag *tag = [[FeedTag alloc]init];
        tag.name = tf.text;
        [self.delegate onTagChooseFinish:tag];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/feed/tag")
                                              parameters:nil cacheType:CacheTypeDisable JSONModelClass:[FeedTagListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if (self.model == nil) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     self.model = responseObject;
                                                     [self.tableView reloadData];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if (self.model == nil) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                 }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedTag *tag = self.model.data.recommendedTags[indexPath.row];
        [self.delegate onTagChooseFinish:tag];
    } else {
        FeedTag *tag = self.model.data.hotTags[indexPath.row];
        [self.delegate onTagChooseFinish:tag];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model == nil) {
        return 0;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    if (section == 0) {
        header = [CommonHeaderView cellWithTableView:self.tableView];
        ((CommonHeaderView * )header).data = @"推荐标签";
    } else if (section == 1) {
        header = [CommonHeaderView cellWithTableView:self.tableView];
        ((CommonHeaderView * )header).data = @"热门标签";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.data.recommendedTags.count;
        
    } else {
        return self.model.data.hotTags.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTag = @"CellItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTag];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    if (indexPath.section == 0) {
        FeedTag *tag = self.model.data.recommendedTags[indexPath.row];
        cell.textLabel.text = tag.name;
    } else {
        FeedTag *tag = self.model.data.hotTags[indexPath.row];
        cell.textLabel.text = tag.name;
    }
    return cell;
}

@end
