//
//  HomeEventCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"


@interface HomeEventCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

- (IBAction)onLeftClicked:(id)sender;
- (IBAction)onRightClicked:(id)sender;


@end
