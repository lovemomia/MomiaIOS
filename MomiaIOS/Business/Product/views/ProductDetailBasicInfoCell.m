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
    self.imgView.image = [UIImage imageNamed:@"IconChild"];
    self.titleLabel.text = data;

}

-(void)setData:(ProductModel *)model withIndex:(NSInteger) index
{
    if(index == 0) {
        self.imgView.image = [UIImage imageNamed:@"IconChild"];
        self.titleLabel.text = model.crowd;
        
    } else if(index == 1) {
        self.imgView.image = [UIImage imageNamed:@"IconAlarm"];
        self.titleLabel.text = model.scheduler;

    } else {
        self.imgView.image = [UIImage imageNamed:@"IconAddress"];
        self.titleLabel.text = model.address;

    }
}


@end
