//
//  FeedZanCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "FeedDetailModel.h"

typedef void (^BlockOnZanClicked)();

@interface FeedZanCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarsView;

@property (nonatomic, strong) BlockOnZanClicked blockOnZanClicked;

- (IBAction)onZanClicked:(id)sender;

- (void)setData:(id)data;

@end
