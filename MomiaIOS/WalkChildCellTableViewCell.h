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

-(void)setData:(Child *)child;

@end
