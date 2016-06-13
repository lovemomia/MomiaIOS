//
//  SubjectTabCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@protocol SubjectTabCellDelegate <NSObject>

- (void)onTabChanged:(NSInteger)index;

@end

@interface SubjectTabCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIButton *tab1Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab2Btn;
@property (weak, nonatomic) IBOutlet UIButton *tab3Btn;

@property (nonatomic, assign) id<SubjectTabCellDelegate> delegate;


- (IBAction)onTab1Clicked:(id)sender;
- (IBAction)onTab2Clicked:(id)sender;
- (IBAction)onTab3Clicked:(id)sender;


@end
