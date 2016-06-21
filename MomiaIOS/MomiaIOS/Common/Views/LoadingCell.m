//
//  LoadingCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LoadingCell.h"

@interface LoadingCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoadingCell

-(void)startAnimating
{
    [self.activityIndicator startAnimating];
}
-(void)stopAnimating
{
    [self.activityIndicator stopAnimating];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
