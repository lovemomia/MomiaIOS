//
//  HomeCarouselCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCarouselCell.h"
#import "IndexModel.h"

#define cellScale 0.45

@interface HomeCarouselCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int imgsNum;//scrollView中imgView的数目

@property (nonatomic,strong) NSTimer * timer;

@end

@implementation HomeCarouselCell

- (void)onScrollClick:(UITapGestureRecognizer *)sender {
    UIScrollView * scroll = (UIScrollView *)sender.view;
    CGFloat pageWidth = scroll.width;
    NSInteger page = scroll.contentOffset.x/pageWidth;
    NSInteger index;
    
    if(self.imgsNum == 1) {
        index = 0;
        
    } else {
        if(page == 0) {
            index = self.imgsNum - 3;
        } else if(page == self.imgsNum - 1) {
            index = 0;
        } else {
            index = page - 1;
        }
    }
    self.scrollClick(index);
}

+(CGFloat)heightWithTableView:(UITableView *)tableView
{
//    return CGRectGetWidth(tableView.bounds) * cellScale;
    return SCREEN_WIDTH * 180 / 320;
}

-(void)setData:(NSArray *) banners
{
    [self layoutIfNeeded];
    
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    
    for (id view in self.scrollView.subviews ) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imgsNum = 0;
    
    self.pageControl.numberOfPages = banners.count;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = MO_APP_ThemeColor;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.alpha = 0.8;
    
    self.scrollView.delegate = self;
    
    if(banners.count == 1) {//只有一张图
        self.pageControl.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(width,0);
        IndexBanner * item = banners[0];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:item.cover] placeholderImage:nil];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.scrollView addSubview:imgView];
        self.imgsNum ++;
        if(self.timer)
            [self.timer invalidate];
    } else {
        self.pageControl.hidden = NO;
        self.scrollView.contentSize = CGSizeMake((banners.count + 2) * width,0);
        
        UIImageView * firstImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        firstImgView.contentMode = UIViewContentModeScaleAspectFill;
        firstImgView.clipsToBounds = YES;
        [firstImgView sd_setImageWithURL:[NSURL URLWithString:((IndexBanner *)banners.lastObject).cover] placeholderImage:nil];
        
        [self.scrollView addSubview:firstImgView];
        self.imgsNum ++;
        
        for (int i = 0; i < banners.count; i++) {
            IndexBanner * item = banners[i];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * width, 0, width, height)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:item.cover] placeholderImage:nil];
            [self.scrollView addSubview:imgView];
            self.imgsNum ++;
        }
        
        UIImageView * lastImgView = [[UIImageView alloc] initWithFrame:CGRectMake((banners.count + 1) * width, 0, width, height)];
        lastImgView.contentMode = UIViewContentModeScaleAspectFill;
        lastImgView.clipsToBounds = YES;
        [lastImgView sd_setImageWithURL:[NSURL URLWithString:((IndexBanner *)banners.firstObject).cover] placeholderImage:nil];
        [self.scrollView addSubview:lastImgView];
        
        self.imgsNum ++;
        
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
        
        if(self.timer)
            [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    
}


-(void)nextPage
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = self.scrollView.contentOffset.x/pageWidth;
    
    if(currentPage == self.imgsNum - 2) {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        currentPage = 0;
    }
    
    [self.scrollView setContentOffset:CGPointMake((currentPage + 1) * pageWidth, 0) animated:YES];
    
   
    self.pageControl.currentPage = currentPage;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.timer) [self.timer invalidate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat width = scrollView.frame.size.width;
    
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    int currentPage = scrollView.contentOffset.x/width;
    
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((self.imgsNum - 2) * width, 0)];
        self.pageControl.currentPage = self.imgsNum - 3;
    } else if (currentPage == self.imgsNum - 1) {
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
    if(self.timer) [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}


- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollClick:)];
    [self.scrollView addGestureRecognizer:gesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
