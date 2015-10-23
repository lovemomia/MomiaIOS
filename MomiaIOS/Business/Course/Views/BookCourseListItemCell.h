//
//  BookCourseListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface BookCourseListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (nonatomic, strong) NSString *pid;

- (IBAction)onBookBtnClicked:(id)sender;


@end
