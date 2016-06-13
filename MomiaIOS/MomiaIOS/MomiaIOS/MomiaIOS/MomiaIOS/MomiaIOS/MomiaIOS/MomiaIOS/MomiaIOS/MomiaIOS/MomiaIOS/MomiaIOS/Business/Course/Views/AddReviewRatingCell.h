//
//  AddReviewRatingCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/3.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "EDStarRating.h"

@interface AddReviewRatingCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingView;


@end
