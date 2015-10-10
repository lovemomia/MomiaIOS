//
//  MOTableCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/15.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MOTableCellDataProtocol <NSObject>

@required
- (void)setData:(id)data;

@end

@interface MOTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *) identifier;

+ (void)registerCellFromNibWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;

+ (void)registerCellFromClassWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier;

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data;


@end
