//
//  ActivityDetailCarouselCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailCarouselCell.h"
#import "NSString+MOAttribuedString.h"
#import "ProductModel.h"

@interface ProductDetailCarouselCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageLabelWidthConstraint;

@property (assign, nonatomic) int imgsNum;

@end

@implementation ProductDetailCarouselCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setData:(ProductModel *)model
{
    [self layoutIfNeeded];
    
    CGFloat width = self.scrollView.width;
    CGFloat height = self.scrollView.height;
    
    for (id view in self.scrollView.subviews ) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imgsNum = 0;
    
    NSArray * array = model.imgs;
    
    NSString * pageLabelStr = [NSString stringWithFormat:@"%d/%ld",1,array.count];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] init];
    
    NSRange range = [pageLabelStr rangeOfString:@"/"];
    
    NSAttributedString * str1 = [[pageLabelStr substringToIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xffffff) andFont:self.pageLabel.font];
    
    NSAttributedString * str2 = [[pageLabelStr substringFromIndex:range.location] attributedStringWithColor:UIColorFromRGB(0x999999) andFont:self.pageLabel.font];
    
    [attrStr appendAttributedString:str1]; [attrStr appendAttributedString:str2];
    
    self.pageLabel.attributedText = attrStr;
    
    
    self.pageLabelWidthConstraint.constant = [UILabel widthForAttributedString:attrStr withHeight:20].size.width + 20;
    self.pageLabel.layer.cornerRadius = 13;
    self.pageLabel.layer.backgroundColor = UIColorFromRGB(0xcccccc).CGColor;
    
//    self.pageControl.numberOfPages = array.count;
//    self.pageControl.currentPage = 0;
    
    self.scrollView.delegate = self;
    
    if(array.count == 0) {
        self.pageLabel.hidden = YES;
    } else if(array.count == 1) {
        self.pageLabel.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(width,0);
        NSString * item = array[0];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
        [self.scrollView addSubview:imgView];
        self.imgsNum ++;
    } else {
        self.pageLabel.hidden = NO;
        self.scrollView.contentSize = CGSizeMake((array.count + 2) * width,0);
        
        UIImageView * firstImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [firstImgView sd_setImageWithURL:[NSURL URLWithString:array.lastObject] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
        [self.scrollView addSubview:firstImgView];
        
        self.imgsNum ++;
        
        for (int i = 0; i < array.count; i++) {
            NSString * item = array[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * width, 0, width, height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
            [self.scrollView addSubview:imgView];
            self.imgsNum ++;
        }
        
        UIImageView * lastImgView = [[UIImageView alloc] initWithFrame:CGRectMake((array.count + 1) * width, 0, width, height)];
        [lastImgView sd_setImageWithURL:[NSURL URLWithString:array.firstObject] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
        [self.scrollView addSubview:lastImgView];
        
        self.imgsNum ++;
        
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
    }
    
    
    self.titleLabel.text = model.title;
    self.enrollLabel.text = [NSString stringWithFormat:@"%ld人已报名",model.joined];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.price];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = scrollView.frame.size.width;
    
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    int currentPage = scrollView.contentOffset.x/width;
    
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((self.imgsNum - 2) * width, 0)];
        currentPage = self.imgsNum - 2;
//        self.pageControl.currentPage = self.imgsNum - 3;
    } else if (currentPage == self.imgsNum - 1) {
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
        currentPage = 1;
//        self.pageControl.currentPage = 0;
    }
    NSString * pageLabelStr = [NSString stringWithFormat:@"%d/%d",currentPage,self.imgsNum - 2];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] init];
    
    NSRange range = [pageLabelStr rangeOfString:@"/"];
    
    NSAttributedString * str1 = [[pageLabelStr substringToIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xffffff) andFont:self.pageLabel.font];
    
    NSAttributedString * str2 = [[pageLabelStr substringFromIndex:range.location] attributedStringWithColor:UIColorFromRGB(0x999999) andFont:self.pageLabel.font];
    
    [attrStr appendAttributedString:str1]; [attrStr appendAttributedString:str2];
    
    self.pageLabel.attributedText = attrStr;
   
}


@end
