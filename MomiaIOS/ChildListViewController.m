//
//  WalkChildsViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ChildListViewController.h"
#import "ConfirmBookViewController.h"
#import "ChildListCell.h"
#import "AccountModel.h"
#import "NSMutableArray+Queue.h"
#import "NSString+MOEncrypt.h"

@interface ChildListViewController ()

@property (nonatomic, assign) NSInteger childCount;
@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) NSInteger choosedChildItem;

@end

@implementation ChildListViewController
//动作有选择宝宝和 出行宝宝两种类型(既action动作) 1.chooseChild  2.updateChild
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        [self decoderParams:params];
    }
    return self;
}

-(void)decoderParams:(NSDictionary *)params{
    self.action = [params objectForKey:@"action"];
    self.choosedChildItem = ((NSNumber *)[params objectForKey:@"choosedChildItem"]).integerValue;
    if ([self.action isEqualToString:@"chooseChild"]) {
        self.title = @"选择宝宝";
    }else{
        self.title = @"出行宝宝";
    }
    Account *account = [AccountService defaultService].account;
    self.childs = account.children;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateUserInfo:) name:@"Notification_UpdateUserInfo" object:nil];
    
    NSMutableArray *good = [[NSMutableArray alloc]initWithCapacity:10];
    [good addObject:@"1"];
    [good addObject:@"2"];
    [good addObject:@"3"];
    [good addObject:@"4"];
    NSLog(@"%@",[good deQueue]);
}

-(void)UpdateUserInfo:(id)sender{
    Account *account = [AccountService defaultService].account;
    self.childs = account.children;
    [self.tableView reloadData];
}

//设置导航
-(void)setNavItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addChild)];
}

#pragma child -- action
-(void)addChild{
    [self openURL:[NSString stringWithFormat:@"childinfo?action=%@",@"add"]];
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

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
         accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
    if ([self.action isEqualToString:@"chooseChild"] && indexPath.row == _choosedChildItem) {
        return UITableViewCellAccessoryCheckmark;
    }
    return UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.action isEqualToString:@"chooseChild"]) {
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
    NSInteger row = indexPath.row;
    static NSString *WalkChildsCellIdentifer = @"ChildListCellReuseInentifer";
    ChildListCell *cell = [tableView dequeueReusableCellWithIdentifier:WalkChildsCellIdentifer];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChildListCell" owner:self options:nil]lastObject];
        [[cell viewWithTag:14]removeFromSuperview];
        [cell setData:self.childs[row] delegate:self];
        if ([self.action isEqualToString:@"chooseChild"]) {
            [[cell viewWithTag:13]removeFromSuperview];
            [[cell viewWithTag:14]removeFromSuperview];
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
    if([self.action isEqualToString:@"chooseChild"]){
        _choosedChildItem = indexPath.row;
        [self.tableView reloadData];
        __weak ConfirmBookViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2 ];
        vc.choosedChildItem = indexPath.row;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
