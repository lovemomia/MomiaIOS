//
//  ActivityDetailBasicInfo.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailBasicInfoCell.h"
#import "ProductModel.h"

@interface ProductDetailBasicInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ProductDetailBasicInfoCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(NSString *)data;
{
    self.imageView.image = [UIImage imageNamed:@"a_d_umbrella"];
    self.titleLabel.text = data;

}

-(void)setData:(ProductModel *)model withIndex:(NSInteger) index
{
    if(index == 0) {
        self.imageView.image = [UIImage imageNamed:@"a_d_umbrella"];
        self.titleLabel.text = model.crowd;
        
    } else if(index == 1) {
        self.imageView.image = [UIImage imageNamed:@"a_d_alarm"];
        self.titleLabel.text = model.scheduler;

    } else {
        self.imageView.image = [UIImage imageNamed:@"a_d_address"];
        self.titleLabel.text = model.address;

    }
}

@end
