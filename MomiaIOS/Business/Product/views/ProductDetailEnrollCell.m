//
//  ActivityDetailEnrollCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailEnrollCell.h"
#import "ProductModel.h"

@interface ProductDetailEnrollCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ProductDetailEnrollCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(ProductCustomersModel *)model
{
    [self layoutIfNeeded];
    
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    for (id view in self.scrollView.subviews ) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    int instrinctNum = 6;
    
    for (int i = 0; i < model.avatars.count; i++) {
        if(i < instrinctNum) {
            NSString * item = model.avatars[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (height + 10) * i, 0, height, height)];
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = height/2;
            [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
            [self.scrollView addSubview:imgView];
        }
    }
    
    self.titleLabel.text = model.text;
}

-(void)awakeFromNib {
    UITableView * tableView = [[UITableView alloc] init];
    self.lineView.backgroundColor = tableView.separatorColor;
}

@end
