//
//  ShareViewCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/18.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface ShareViewCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *photoIv;
@property (weak, nonatomic) IBOutlet UILabel *discLabel;

- (IBAction)onShareClicked:(id)sender;


@end
