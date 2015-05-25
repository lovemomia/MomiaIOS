//
//  CommentCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)heightWithData:(CommentItem *)data;

- (void)setData:(CommentItem *)data;

@end

