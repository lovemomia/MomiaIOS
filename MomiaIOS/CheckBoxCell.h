//
//  CheckBoxCell.h
//  MomiaIOS
//
//  Created by mosl on 16/5/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckDotView.h"

@interface CheckBoxCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CheckDotView *checkDotView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,strong) NSString *detailText;

@end
