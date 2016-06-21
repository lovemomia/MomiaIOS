//
//  WalkChildsViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ChildListViewController.h"
#import "ChildListCell.h"
#import "AccountModel.h"
#import "NSString+MOEncrypt.h"

static NSString *ChooseChildAction = @"ChooseChildAction";
static NSString *ChildListAction = @"ChildListAction";
static NSString *ChoosedChildId = @"ChoosedChildId";

@interface ChildListViewController ()<AccountChangeListener>

@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) NSNumber *choosedChildId;
@property (nonatomic, strong) NSMutableArray *childs;

@end

@implementation ChildListViewController
//动作有选择宝宝和 出行宝宝两种类型(既action动作) 1.chooseChild  2.ChildList
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        [self decoderParams:params];
    }
    return self;
}

-(void)decoderParams:(NSDictionary *)params{
    NSNumber* select = [params objectForKey:@"select"];
    BOOL isSelect = [select boolValue];
    if (isSelect) {
        self.title = @"选择宝宝";
        self.action = ChooseChildAction;
        self.choosedChildId = [params objectForKey:@"cid"];
    } else {
        self.title = @"出行宝宝";
    }
    Account *account = [AccountService defaultService].account;
    self.childs = account.children;
    if (self.childs.count == 0) {
        [self.view showEmptyView:@"还没有宝宝呢，赶紧添加一个吧～"];
    }
}

-(NSString *)action{ //action 默认是List
    if (!_action) {
        _action = ChildListAction;
    }
    return _action;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [[AccountService defaultService]addListener:self];
}


-(void)onAccountChange{
    Account *account = [AccountService defaultService].account;
    self.childs = account.children;
    if (self.childs.count == 0) {
        [self.view showEmptyView:@"还没有宝宝呢，赶紧添加一个吧～"];
    } else {
        [self.view removeEmptyView];
    }
    [self.tableView reloadData];
}

//设置导航
-(void)setNavItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addChildAction)];
}

#pragma child -- action
-(void)addChildAction{
    [self openURL:@"childinfo"];
}

- (void)deleteChild:(NSNumber *)ids {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"cid" : [NSString stringWithFormat:@"%@", ids]};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/delete")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  AccountModel *result = (AccountModel *)responseObject;
                                  [AccountService defaultService].account = result.data;
                                  
                                  [self.tableView reloadData];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

#pragma UITableView -- datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.childs.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.action isEqualToString:ChooseChildAction]) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Child *child = _childs[indexPath.row];
        [self deleteChild:child.ids];
        [_childs removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        //广播删除消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_DeleteInfo" object:nil userInfo:nil];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Child *child = self.childs[indexPath.row];
    static NSString *WalkChildsCellIdentifer = @"ChildListCellReuseInentifer";
    ChildListCell *cell = [tableView dequeueReusableCellWithIdentifier:WalkChildsCellIdentifer];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChildListCell" owner:self options:nil]lastObject];
        [[cell viewWithTag:14]removeFromSuperview];
        [cell setData:child delegate:self];
        if ([self.action isEqualToString:ChooseChildAction]) {
            [[cell viewWithTag:14]setHidden:YES];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.ownerVC = self;
    return cell;
}

#pragma UITableView -- delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.action isEqualToString:ChooseChildAction]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateChoosedChild" object:[[NSNumber alloc]initWithInteger:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
