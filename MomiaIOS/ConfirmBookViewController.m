//
//  ConfirmBookViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ConfirmBookViewController.h"
#import "Masonry.h"
#import "CourseLocationTimeCell.h"
#import "Account.h"
#import "AccountModel.h"
#import "WalkChildsViewController.h"

//确认约课
@interface ConfirmBookViewController ()

@property(strong,nonatomic) NSArray *childs;

@end

@implementation ConfirmBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"确认约课";
    //由于本地没存孩子信息，需要从服务端拿
    [self fromServerGetAccount];
    
    //拿到孩子
    Account *account = [AccountService defaultService].account;
    _childs = account.children;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_childs.count == 0) {
        return 1;
    }
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if(section == 1 && _childs.count == 0){
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 120;
    }
    else if (indexPath.section == 1 && _childs.count == 0) {
        return 40;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//section 头部
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc]init];
    
    if (section == 0) {
        label.text = @"上课时间地点";
    }else{
        label.text = @"出行宝宝";
    }
    
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //选择宝宝
    if (indexPath.section == 1 && _childs.count != 0) {
        
        WalkChildsViewController *walkChildsVC = [[WalkChildsViewController alloc]init];
        [self.navigationController pushViewController:walkChildsVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"确认预约" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onConfirmBook:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

//提交到服务器
-(void)onConfirmBook:(id)sender{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        
        CourseLocationTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseLocationTimeCell"];
        if (cell == nil) {
            cell = [[CourseLocationTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseLocationTimeCell"];
            
        }
        return cell;
        
    }
    
    UITableViewCell *cell;
    if (indexPath.section == 1 && _childs.count == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDefault"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 15.0];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"WalkChildsCellIdentifer"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WalkChildCellTableViewCell" owner:self options:nil]lastObject];
            [[cell viewWithTag:13]removeFromSuperview];
            UIButton *button = [cell viewWithTag:14];
            [button setTitle:@"选择宝宝" forState:UIControlStateNormal];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)fromServerGetAccount {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user")
                          parameters:nil cacheType:CacheTypeDisable JSONModelClass:[AccountModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 AccountModel *result = (AccountModel *)responseObject;
                                 [AccountService defaultService].account = result.data;
                                 Account *account = [AccountService defaultService].account;
                                 _childs = account.children;
                                 [self.tableView reloadData];
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}

@end
