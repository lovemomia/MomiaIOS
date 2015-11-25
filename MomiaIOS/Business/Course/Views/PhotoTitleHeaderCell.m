//
//  PhotoTitleHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "PhotoTitleHeaderCell.h"
#import "MONetworkPhotoView.h"
#import "Subject.h"
#import "Course.h"
#import "NSString+MOAttribuedString.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface PhotoTitleHeaderCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageLabelBg;

@property (nonatomic, strong) NSArray *imgs;


@property (assign, nonatomic) int imgsNum;
@property (assign, nonatomic) int currentPage;

@end

@implementation PhotoTitleHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return SCREEN_WIDTH * 225 / 320;
}

-(void)setData:(id)model
{
    BOOL isPackage = [model isKindOfClass:[Subject class]];
    [self layoutIfNeeded];
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_WIDTH * 225 / 320;
    
    for (id view in self.scrollView.subviews ) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.imgsNum = 0;
    
    NSArray * array = isPackage ? ((Subject *)model).imgs : ((Course *)model).imgs;
    self.imgs = array;
    NSString * pageLabelStr = [NSString stringWithFormat:@"%d/%ld",1,(unsigned long)array.count];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] init];
    NSRange range = [pageLabelStr rangeOfString:@"/"];
    NSAttributedString * str1 = [[pageLabelStr substringToIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xffffff) andFont:self.pageLabel.font];
    
    NSAttributedString * str2 = [[pageLabelStr substringFromIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xcccccc) andFont:self.pageLabel.font];
    
    [attrStr appendAttributedString:str1]; [attrStr appendAttributedString:str2];
    
    self.pageLabel.attributedText = attrStr;
    
    self.scrollView.delegate = self;
    
    if(array.count == 0) {
        self.pageLabel.hidden = YES;
        self.pageLabelBg.hidden = YES;
        
    } else if(array.count == 1) {
        self.pageLabel.hidden = YES;
        self.pageLabelBg.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(width,0);
        NSString * item = array[0];
        MONetworkPhotoView * imgView = [[MONetworkPhotoView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:nil];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.scrollView addSubview:imgView];
        self.imgsNum ++;
    } else {
        self.pageLabel.hidden = NO;
        self.scrollView.contentSize = CGSizeMake((array.count + 2) * width,0);
        
        MONetworkPhotoView * firstImgView = [[MONetworkPhotoView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [firstImgView sd_setImageWithURL:[NSURL URLWithString:array.lastObject]];
        firstImgView.clipsToBounds = YES;
        firstImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:firstImgView];
        
        self.imgsNum ++;
        
        for (int i = 0; i < array.count; i++) {
            NSString * item = array[i];
            MONetworkPhotoView * imgView = [[MONetworkPhotoView alloc] initWithFrame:CGRectMake((i + 1) * width, 0, width, height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:nil];
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.scrollView addSubview:imgView];
            self.imgsNum ++;
        }
        
        MONetworkPhotoView * lastImgView = [[MONetworkPhotoView alloc] initWithFrame:CGRectMake((array.count + 1) * width, 0, width, height)];
        [lastImgView sd_setImageWithURL:[NSURL URLWithString:array.firstObject] placeholderImage:nil];
        lastImgView.clipsToBounds = YES;
        lastImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:lastImgView];
        
        self.imgsNum ++;
        
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageClick:)];
        [self.scrollView addGestureRecognizer:singleTap];
    }
    
}

- (void)onImageClick:(UIGestureRecognizer *)recognizer {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.imgs.count];
    for (int i = 0; i < self.imgs.count; i++) {
        NSString *url = [self.imgs objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = self.currentPage == 0 ? 0 : (self.currentPage - 1);
    browser.photos = photos;
    [browser show];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    
    //当手指滑动scrollview，而scrollview减速停止的时候 开始计算当前的图片的位置
    self.currentPage = scrollView.contentOffset.x/width;
    
    if (self.currentPage == 0) {
        [scrollView setContentOffset:CGPointMake((self.imgsNum - 2) * width, 0)];
        self.currentPage = self.imgsNum - 2;
        //        self.pageControl.currentPage = self.imgsNum - 3;
    } else if (self.currentPage == self.imgsNum - 1) {
        [self.scrollView setContentOffset:CGPointMake(width, 0)];
        self.currentPage = 1;
        //        self.pageControl.currentPage = 0;
    }
    NSString * pageLabelStr = [NSString stringWithFormat:@"%d/%d", self.currentPage,self.imgsNum - 2];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] init];
    
    NSRange range = [pageLabelStr rangeOfString:@"/"];
    
    NSAttributedString * str1 = [[pageLabelStr substringToIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xffffff) andFont:self.pageLabel.font];
    
    NSAttributedString * str2 = [[pageLabelStr substringFromIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xcccccc) andFont:self.pageLabel.font];
    
    [attrStr appendAttributedString:str1]; [attrStr appendAttributedString:str2];
    
    self.pageLabel.attributedText = attrStr;
}

@end
