//
//  UserTimelineCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface UserTimelineCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *reviewContainer;

- (IBAction)onCourseClicked:(id)sender;

@end
