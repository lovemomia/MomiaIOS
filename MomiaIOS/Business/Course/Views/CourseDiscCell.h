//
//  CourseDiscCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

@interface CourseDiscCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(id)model reuseIdentifier:(NSString *)identifier;

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model;

@end
