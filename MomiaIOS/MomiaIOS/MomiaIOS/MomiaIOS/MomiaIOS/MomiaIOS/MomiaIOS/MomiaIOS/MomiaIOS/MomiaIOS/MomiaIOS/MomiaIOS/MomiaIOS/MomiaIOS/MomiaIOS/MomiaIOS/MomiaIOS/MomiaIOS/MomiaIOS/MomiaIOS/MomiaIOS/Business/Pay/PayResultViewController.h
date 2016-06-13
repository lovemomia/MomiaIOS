//
//  PayResultViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface PayResultViewController : MOViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


- (IBAction)onLeftButtonClicked:(id)sender;
- (IBAction)onRightButtonClicked:(id)sender;


@end
