//
//  ProductDetailTagsCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailTagsCell.h"

@interface ProductDetailTagsCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProductDetailTagsCell


-(void)setData:(ProductModel *)model
{
    
    for (UIView * view in self.scrollView.subviews) {
        if([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView * lastView;
    
    for (int i = 0 ; i < model.tags.count ; i++) {
        
        NSString * tag = model.tags[i];
        
        UIImageView * imgView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
            if(i == 0) make.leading.equalTo(self.scrollView).with.offset(10);
            else make.leading.equalTo(lastView.mas_trailing).with.offset(50);
            make.width.equalTo(@15.7);
            make.height.equalTo(@15.7);
        }];
        [imgView setImage:[UIImage imageNamed:@"productdetail_suishitui"]];
        
        UILabel * label = [[UILabel alloc] init];
        [self.scrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
            make.leading.equalTo(imgView.mas_trailing).with.offset(10);
        }];
        label.text = tag;
        label.textColor = UIColorFromRGB(0x00c49d);
        label.font = [UIFont systemFontOfSize:13.0f];
        
        lastView = label;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
