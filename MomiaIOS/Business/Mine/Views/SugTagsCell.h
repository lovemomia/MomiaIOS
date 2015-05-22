//
//  SugSubmitTagsCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SugTagsModel.h"

@interface SugTagsCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                         withData:(NSArray *)tags;

@end
