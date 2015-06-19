//
//  ActivityDetailLinkCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ActivityDetailLinkCell.h"
#import "ProductModel.h"

@interface ActivityDetailLinkCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ActivityDetailLinkCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(ProductContentModel *)model
{
    NSArray * array = model.body;
    for (int i = 0; i < array.count; i++) {
        ProductBodyModel * model = array[i];
        if(model.link) {
            if(model.text) {
                self.titleLabel.text = model.text;
            }
        }
    }
}


@end
