//
//  HomeCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@class ProductModel;

@interface HomeCell : MOTableCell<MOTableCellDataProtocol>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImgWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImgWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

-(void)setData:(ProductModel *) model;

@end