//
//  FeedZanCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FeedZanCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarsView;


- (IBAction)onZanClicked:(id)sender;

-(void)setData:(id)data;

@end
