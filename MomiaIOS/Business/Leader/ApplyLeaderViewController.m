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
    
    [ApplyLeaderHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierApplyLeaderHeaderCell];
    [ApplyLeaderIntroHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierApplyLeaderIntroHeaderCell];
    [ApplyLeaderIntroContentCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierApplyLeaderIntroContentCell];
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

- (void)setModel:(LeaderStatusModel *)model {
    _model = model;
    [self.tableView reloadData];
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
    if (self.model == nil) {
        return 0;
    } else if ([self.model.data.status intValue] == 3) {
        return 2;
    }
    return [self.model.data.desc.content count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if ([self.model.data.status intValue] == 3) {
        return 2;
    }
    LeaderStatusDescContent *contentModel = [self.model.data.desc.content objectAtIndex:section - 1];
    return [contentModel.body count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_HEIGHT - 65;
        
    } else if (indexPath.row == 0) {
        NSString *title;
        if ([self.model.data.status intValue] == 3) {
            title = @"未通过原因";
        } else {
            title = ((LeaderStatusDescContent *)[self.model.data.desc.content objectAtIndex:indexPath.section - 1]).title;
        }
        return [ApplyLeaderIntroHeaderCell heightWithTableView:tableView withIdentifier:identifierApplyLeaderIntroHeaderCell forIndexPath:indexPath data:title];
        
    } else {
        NSString *content;
        if ([self.model.data.status intValue] == 3) {
            content = self.model.data.msg;
            
        } else {
            LeaderStatusDescContent *contentModel = [self.model.data.desc.content objectAtIndex:indexPath.section - 1];
            content = ((LeaderStatusDescContentBody *)[contentModel.body objectAtIndex:indexPath.row - 1]).text;
            if ([contentModel.body count] > 1) {
                content = [NSString stringWithFormat:@"- %@", content];
            }
        }
        return [ApplyLeaderIntroContentCell heightWithTableView:tableView withIdentifier:identifierApplyLeaderIntroContentCell forIndexPath:indexPath data:content];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ApplyLeaderHeaderCell *header = [ApplyLeaderHeaderCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderHeaderCell];
        if ([self.model.data.status intValue] == 2) {
            [header.applyBtn setTitle:@"正在审核中..." forState:UIControlStateDisabled];
            header.applyBtn.enabled = NO;
            
        } else if ([self.model.data.status intValue] == 3) {
            [header.applyBtn setTitle:@"重新申请当领队" forState:UIControlStateNormal];
            
        } else {
            [header.applyBtn setTitle:@"我要当领队" forState:UIControlStateNormal];
        }
        [header.applyBtn addTarget:self action:@selector(onApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailClick)];
        [header.detailLabel addGestureRecognizer:tapRecognizer];
        cell = header;
        
    } else if (indexPath.row == 0) {
        ApplyLeaderIntroHeaderCell *header = [ApplyLeaderIntroHeaderCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderIntroHeaderCell];

        if ([self.model.data.status intValue] == 3) {
            header.data = @"未通过原因";
        } else {
            header.data = ((LeaderStatusDescContent *)[self.model.data.desc.content objectAtIndex:indexPath.section - 1]).title;
        }
        cell = header;
        
    } else {
        ApplyLeaderIntroContentCell *intro = [ApplyLeaderIntroContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierApplyLeaderIntroContentCell];
        if ([self.model.data.status intValue] == 3) {
            intro.data = self.model.data.msg;
            
        } else {
            LeaderStatusDescContent *contentModel = [self.model.data.desc.content objectAtIndex:indexPath.section - 1];
            NSString *content = ((LeaderStatusDescContentBody *)[contentModel.body objectAtIndex:indexPath.row - 1]).text;
            if ([contentModel.body count] > 1) {
                content = [NSString stringWithFormat:@"- %@", content];
            }
            intro.data = content;
        }
        
        cell = intro;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 35;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 50;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
