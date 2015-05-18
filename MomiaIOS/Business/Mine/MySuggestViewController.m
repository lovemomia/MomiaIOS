//
//  MySuggestViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MySuggestViewController.h"

@interface MySuggestViewController ()

@end

@implementation MySuggestViewController

/* tableView分割线，默认无 */
- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"好物";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我要推荐" style:UIBarButtonItemStylePlain target:self action:@selector(onSuggestClicked)];
    //当单元格数目少于屏幕时会出现多余分割线，直接设置tableFooterView用以删除
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

- (void)onSuggestClicked {
    [self openURL:@"momia://sugsubmit"];
}


#pragma mark - tableview delegate & datasource


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //注：我的推荐视图跟我的收藏一样，直接使用收藏的xib
    static NSString *identifier = @"CollectionCell";
    
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyCollectionCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = MO_APP_VCBackgroundColor;
    }
    
    return cell;
}


@end
