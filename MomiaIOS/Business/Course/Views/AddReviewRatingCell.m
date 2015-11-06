//
//  AddReviewRatingCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/3.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "AddReviewRatingCell.h"

@interface AddReviewRatingCell()

@end

@implementation AddReviewRatingCell
@synthesize ratingView;

- (void)awakeFromNib {
    // Initialization code
    
    ratingView.starImage = [UIImage imageNamed:@"IconGrayStar"];
    ratingView.starHighlightedImage = [UIImage imageNamed:@"IconRedStar"];
    ratingView.maxRating = 5.0;
    ratingView.horizontalMargin = 12;
    ratingView.editable=YES;
    ratingView.displayMode=EDStarRatingDisplayFull;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data {
    
}


@end
