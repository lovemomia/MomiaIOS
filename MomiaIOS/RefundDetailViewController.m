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
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        RefundLabelCell *refundLabelCell = [self.tableView dequeueReusableCellWithIdentifier:RefundLableCellIdentifer];
        switch (indexPath.row) {
            case 0:
                refundLabelCell.refundTextLabel.text = @"退款金额";
                refundLabelCell.refundDetailTextLabel.text = @"￥399";
                break;
            case 1:
                refundLabelCell.refundTextLabel.text = @"数量";
                refundLabelCell.refundDetailTextLabel.text = @"1";
                break;
            default:
                refundLabelCell.refundTextLabel.text = @"退回账户";
                refundLabelCell.refundDetailTextLabel.text = @"支付账户";
                break;
        }
        cell = refundLabelCell;
    } else {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"退款流程";
        } else {
            RefundTimeLineCell *refundTimeLineCell = [self.tableView dequeueReusableCellWithIdentifier:RefundTimeLineCellIdentifier];
            switch (indexPath.row) {
                case 1:
                    [refundTimeLineCell.topLine setHidden:YES];
                    [refundTimeLineCell.numberLabel setText:@"1"];
                    [refundTimeLineCell.applyTitle setText:@"申请已提交"];
                    [refundTimeLineCell.applyDetail setText:@"您的退款申请已成功提交"];
                    break;
                case 2:
                    [refundTimeLineCell.numberLabel setText:@"2"];
                    [refundTimeLineCell.applyTitle setText:@"松果处理中"];
                    [refundTimeLineCell.applyDetail setText:@"您的退款申请已受理，松果会尽快完成审核,部分情况需要1-2个工作日。"];
                    break;
                case 3:
                    [refundTimeLineCell.numberLabel setText:@"3"];
                    [refundTimeLineCell.applyTitle setText:@"申请已提交"];
                    [refundTimeLineCell.applyDetail setText:@"您的退款申请已成功提交"];
                    [refundTimeLineCell.bottomLine setHidden:YES];
                    break;
            }
            cell = refundTimeLineCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        return 30;
    } else if(indexPath.row == 0) {
        return 44;
    } else if(indexPath.row == 1){
        return 60;
    }
    return 80;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        return UIEdgeInsetsMake(0,10,0,0);
    }
    return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
