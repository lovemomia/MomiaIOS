//
//  ApplyLeaderViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ApplyLeaderViewController.h"

#import "ApplyLeaderHeaderCell.h"
#import "ApplyLeaderIntroHeaderCell.h"
#import "ApplyLeaderIntroContentCell.h"


static NSString *identifierApplyLeaderHeaderCell = @"ApplyLeaderHeaderCell";
static NSString *identifierApplyLeaderIntroHeaderCell = @"ApplyLeaderIntroHeaderCell";
static NSString *identifierApplyLeaderIntroContentCell = @"ApplyLeaderIntroContentCell";

@interface ApplyLeaderViewController ()

@end

@implementation ApplyLeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"成为领队";
    
    [ApplyLeaderHeaderCell registerCellWithTableView:self.tableView withIdentifier:identifierApplyLeaderHeaderCell];
    [ApplyLeaderIntroHeaderCell registerCellWithTableView:self.tableView withIdentifier:identifierApplyLeaderIntroHeaderCell];
    [ApplyLeaderIntroContentCell registerCellWithTableView:self.tableView withIdentifier:identifierApplyLeaderIntroContentCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleNone;
}

- (void)onApplyBtnClick {
    [self openURL:@"duola://submitleader"];
}

- (void)onDetailClick {
    [self.tableView scrollToRowAtIndexPath:[[NSIndexPath alloc] initWithIndex:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT - 65;
        
    } else if (indexPath.row == 0) {
        return [ApplyLeaderIntroHeaderCell heightWithTableView:tableView withIdentifier:identifierApplyLeaderIntroHeaderCell forIndexPath:indexPath data:@"成为领队，你将获得"];
        
    } else {
        return [ApplyLeaderIntroContentCell heightWithTableView:tableView withIdentifier:identifierApplyLeaderIntroContentCell forIndexPath:indexPath data:@"哈哈哈哈哈哈"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ApplyLeaderHeaderCell *header = [ApplyLeaderHeaderCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderHeaderCell];
        [header.applyBtn addTarget:self action:@selector(onApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailClick)];
        [header.detailLabel addGestureRecognizer:tapRecognizer];
        cell = header;
        
    } else if (indexPath.row == 0) {
        cell = [ApplyLeaderIntroHeaderCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderIntroHeaderCell];
    } else {
        cell = [ApplyLeaderIntroContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderIntroContentCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
