//
//  OrderContactViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "FillOrderModel.h"

typedef void(^OnContactFinishClick)();

@interface OrderContactViewController : MOViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) OnContactFinishClick onContactFinishClick;
@property(nonatomic,strong) FillOrderContactsModel * model;

@end
