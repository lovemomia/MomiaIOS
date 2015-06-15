//
//  HomeCarouselCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCarouselCell.h"
#import "HomeModel.h"

#define cellScale 0.45

@interface HomeCarouselCell ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) int imgsNum;//scrollView中imgView的数目

@property (nonatomic,strong) NSTimer * timer;

@end

@implementation HomeCarouselCell


+(CGFloat)heightWithTableView:(UITableView *)tableView
{
    return CGRectGetWidth(tableView.bounds) * cellScale;
}

-(void)setData:(HomeCarouselData *) data
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    for (id view in self.scrollView.subviews ) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imgsNum = 0;
    
    self.pageControl.numberOfPages = data.list.count;
    self.pageControl.currentPage = 0;
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake((data.list.count + 2) * width,0);
    
   
    
    UIImageView * firstImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    firstImgView.image = [UIImage imageNamed:[(HomeCarouselItem *)[data.list lastObject] url]];
    [self.scrollView addSubview:firstImgView];
    self.imgsNum ++;
    
    for (int i = 0; i < data.list.count; i++) {
        HomeCarouselItem * item = data.list[i];
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i + 1) * width, 0, width, height)];
        imgView.image = [UIImage imageNamed:item.url];
        [self.scrollView addSubview:imgView];
        self.imgsNum ++;
    }
    
    UIImageView * lastImgView = [[UIImageView alloc] initWithFrame:CGRectMake((data.list.count + 1) * width, 0, width, height)];
    lastImgView.image = [UIImage imageNamed:[(HomeCarouselItem *)[data.list firstObject] url]];
    [self.scrollView addSubview:lastImgView];
    
    self.imgsNum ++;
    
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
    
    if(self.timer)
        [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
