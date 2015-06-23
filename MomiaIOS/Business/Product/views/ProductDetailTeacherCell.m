//
//  ActivityDetailTeacherCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailTeacherCell.h"
#import "ProductModel.h"

@interface ProductDetailTeacherCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ProductDetailTeacherCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setData:(ProductContentModel *) model
{
  
    
    NSArray * array = model.body;
    for (int i = 0; i < array.count; i++) {
        ProductBodyModel * model = array[i];
        if(model.img) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
            break;
        }
    }
    
    for (int i = 0; i < array.count; i++) {
        ProductBodyModel * model = array[i];
        if(model.text) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 13.0f;
            NSDictionary * dic = @{NSParagraphStyleAttributeName:paragraphStyle};
            NSAttributedString * as = [[NSAttributedString alloc] initWithString:model.text attributes:dic];
            [self.titleLabel setAttributedText:as];
            break;
        }
    }
}

@end
