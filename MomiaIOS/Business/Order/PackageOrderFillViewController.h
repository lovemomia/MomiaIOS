//
//  PackageOrderFillViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"

@interface PackageOrderFillViewController : MOViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)onOkClicked:(id)sender;

@end
