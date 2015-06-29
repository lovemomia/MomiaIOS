//
//  PlaymateUserCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaymateUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameTv;
@property (weak, nonatomic) IBOutlet UILabel *introTv;
@property (weak, nonatomic) IBOutlet UILabel *dateTv;


+ (instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

+ (CGFloat)height;

@end
