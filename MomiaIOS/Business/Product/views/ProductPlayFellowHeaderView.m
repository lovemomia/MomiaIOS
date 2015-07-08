//
//  ProductPlayFellowHeaderView.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductPlayFellowHeaderView.h"

static NSString * identifier = @"p_p_f_header";

@interface ProductPlayFellowHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@end

@implementation ProductPlayFellowHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)headerWithTableView:(UITableView *)tableView
{
    ProductPlayFellowHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return view;
}

+(void)registerHeaderWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

-(void)setData:(PlayFellowListModel *)model
{
    self.timeLabel.text = model.date;
    self.enrollLabel.text = model.text;
    if([model.selected boolValue]) {
        [self.selectImgView setImage:[UIImage imageNamed:@"p_p_f_shouqi"]];
    } else {
        [self.selectImgView setImage:[UIImage imageNamed:@"p_p_f_xiala"]];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderClick:)];
    [self addGestureRecognizer:tapGesture];
}

-(void)onHeaderClick:(UITapGestureRecognizer *)tapGesture
{
    self.onClickHeaderBlock(tapGesture);
}

@end
