//
//  BookCourseListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "Course.h"

@protocol BookCourseListItemCellDelegate <NSObject>

- (void)onBookBtnClick:(Course *)course;

@end

@interface BookCourseListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *iconIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookBtn;

@property (nonatomic, assign) id<BookCourseListItemCellDelegate> delegate;

- (IBAction)onBookBtnClicked:(id)sender;


@end
