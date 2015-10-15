//
//  HomeCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "Package.h"

@interface HomeCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enrollmentBg;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

-(void)setData:(Package *) model;

@end
