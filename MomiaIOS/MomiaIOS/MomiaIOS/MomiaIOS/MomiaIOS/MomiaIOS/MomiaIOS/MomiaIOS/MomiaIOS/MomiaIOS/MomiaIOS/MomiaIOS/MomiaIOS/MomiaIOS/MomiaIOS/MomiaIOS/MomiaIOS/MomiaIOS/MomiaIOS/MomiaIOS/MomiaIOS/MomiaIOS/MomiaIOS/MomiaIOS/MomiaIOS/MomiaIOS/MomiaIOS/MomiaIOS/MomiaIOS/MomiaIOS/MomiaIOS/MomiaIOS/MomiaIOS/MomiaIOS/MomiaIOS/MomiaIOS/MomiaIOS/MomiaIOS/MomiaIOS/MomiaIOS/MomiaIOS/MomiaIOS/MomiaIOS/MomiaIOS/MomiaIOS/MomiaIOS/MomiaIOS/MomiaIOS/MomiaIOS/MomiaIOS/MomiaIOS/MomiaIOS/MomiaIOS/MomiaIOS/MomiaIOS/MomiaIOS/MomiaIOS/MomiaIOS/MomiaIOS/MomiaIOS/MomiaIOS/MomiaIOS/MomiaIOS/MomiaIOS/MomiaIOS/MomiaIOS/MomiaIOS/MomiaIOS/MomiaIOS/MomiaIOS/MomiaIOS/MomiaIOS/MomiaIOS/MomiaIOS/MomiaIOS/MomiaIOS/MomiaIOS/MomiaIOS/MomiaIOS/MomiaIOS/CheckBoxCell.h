//
//  CheckBoxCell.h
//  MomiaIOS
//
//  Created by mosl on 16/5/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

-(void)setDetailText:(NSString *)detailText;

@end
