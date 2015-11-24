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

@interface PhotoTitleHeaderCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (assign, nonatomic) int imgsNum;

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
    } else if(array.count == 1) {
        self.pageLabel.hidden = NO;
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
    }
    
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
    
    NSAttributedString * str2 = [[pageLabelStr substringFromIndex:range.location] attributedStringWithColor:UIColorFromRGB(0xcccccc) andFont:self.pageLabel.font];
    
    [attrStr appendAttributedString:str1]; [attrStr appendAttributedString:str2];
    
    self.pageLabel.attributedText = attrStr;
}

@end
