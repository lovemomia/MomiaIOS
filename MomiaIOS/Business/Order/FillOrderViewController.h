//
//  FillOrderViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "UITextView+Placeholder.h"

@interface FillOrderViewController : MOViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MOTextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
