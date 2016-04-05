//
//  WalkChildsViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WalkChildsViewController.h"
#import "WalkChildCellTableViewCell.h"
#import "ChildDetailViewController.h"


@interface WalkChildsViewController ()

@property(nonatomic,assign) NSInteger childCount;
@property(nonatomic,strong) NSArray *childs;

@end

@implementation WalkChildsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"出行宝宝";
    [self setNavItem];
    
    Account *account = [AccountService defaultService].account;
    self.childs = account.children;
}


//设置导航
-(void)setNavItem{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addChild)];
}

-(void)addChild{
    
    ChildDetailViewController *childDetailVC = [[ChildDetailViewController alloc]init];
    [self.navigationController pushViewController:childDetailVC animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.childs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *WalkChildsCellIdentifer = @"WalkChildsCellInentifer";
    WalkChildCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WalkChildsCellIdentifer];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WalkChildCellTableViewCell" owner:self options:nil]lastObject];
        [[cell viewWithTag:14]removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ownerVC = self;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
