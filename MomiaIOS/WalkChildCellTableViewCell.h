//
//  WalkChildCellTableViewCell.h
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Child.h"

@interface WalkChildCellTableViewCell : UITableViewCell


@property(nonatomic,weak) UIViewController* ownerVC;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

-(void)setData:(Child *)child;

@end
