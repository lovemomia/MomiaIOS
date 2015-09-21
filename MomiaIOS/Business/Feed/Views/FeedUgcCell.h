//
//  PlaymateUgcCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FeedUgcCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

- (IBAction)onCommentBtnClick:(id)sender;
- (IBAction)onZanBtnClick:(id)sender;


-(void)setData:(id)data;

@end
