//
//  SubjectCourseCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "MONetworkPhotoView.h"

@interface SubjectCourseCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;
@property (weak, nonatomic) IBOutlet MONetworkPhotoView *coverIv;


@end
