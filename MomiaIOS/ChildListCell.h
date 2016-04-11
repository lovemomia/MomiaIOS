//
//  WalkChildCellTableViewCell.h
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Child.h"
#import "ChildListViewController.h"

@interface ChildListCell : UITableViewCell

@property(nonatomic,weak) UIViewController* ownerVC;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) Child *child;

-(void)setData:(Child *)child delegate:(ChildListViewController *)controller;

@end
