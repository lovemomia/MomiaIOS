//
//  ApplyCaskBackViewController.h
//  MomiaIOS
//
//  Created by mosl on 16/4/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "OrderDetailModel.h"

//申请退款
@interface ApplyRefundViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) OrderDetailModel *model;

@end
