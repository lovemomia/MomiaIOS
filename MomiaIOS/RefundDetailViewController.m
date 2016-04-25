//
//  RefundViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "RefundDetailViewController.h"
#import "RefundLabelCell.h"
#import "RefundTimeLineCell.h"

static NSString* RefundTimeLineCellIdentifier = @"RefundTimeLineCellIdentifier";
static NSString* RefundLableCellIdentifer = @"RefundLableCellIdentifer";

@interface RefundDetailViewController ()

@end

@implementation RefundDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [RefundTimeLineCell registerCellFromNibWithTableView:self.tableView withIdentifier:RefundTimeLineCellIdentifier];
    [RefundLabelCell registerCellFromNibWithTableView:self.tableView withIdentifier:RefundLableCellIdentifer];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    } else {
        return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:RefundLableCellIdentifer];
    } else {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
            cell.textLabel.text = @"退款流程";
        } else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:RefundTimeLineCellIdentifier];
            if (indexPath.row == 1) {
                 [((RefundTimeLineCell *)cell).topLine setHidden:YES];
            } else if (indexPath.row == 4){
                [((RefundTimeLineCell *)cell).bottomLine setHidden:YES];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
