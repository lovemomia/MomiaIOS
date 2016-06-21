//
//  HomeSubjectCoursesCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface HomeSubjectCoursesCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *coursesContainer;

@end
