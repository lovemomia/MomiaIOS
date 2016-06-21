//
//  CourseTeacherListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface CourseTeacherListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;


@end
