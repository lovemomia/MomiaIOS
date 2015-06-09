//
//  FillOrderRemarkCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillOrderRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+(void)registerCellWithTableView:(UITableView *)tableView;

+(CGFloat)height;

-(void)setPlaceHolder:(NSString *)placeHolder;

@end
