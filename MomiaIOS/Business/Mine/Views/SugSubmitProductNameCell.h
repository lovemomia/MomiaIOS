//
//  SugSubmitProductCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SugSubmitProductNameCell : UITableViewCell

@property (strong, nonatomic)UITextView *nameTv;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)height;

@end
