//
//  ReviewListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/5.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ReviewListItemCell.h"
#import "ReviewList.h"
#import "Child.h"
#import "TTTAttributedLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define LineSpacing 4
#define contentFontSize 13.0f
#define bottomPadding 0

@interface ReviewListItemCell()
@property (nonatomic, strong) Review *review;
@end

@implementation ReviewListItemCell
@synthesize starView;

- (void)awakeFromNib {
    // Initialization code
    
    starView.starImage = [UIImage imageNamed:@"IconSmallGrayStar"];
    starView.starHighlightedImage = [UIImage imageNamed:@"IconSmallRedStar"];
    starView.maxRating = 5.0;
    starView.horizontalMargin = 12;
    starView.editable = YES;
    starView.displayMode = EDStarRatingDisplayFull;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Review *)data {
    self.review = data;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
    self.nameLabel.text = data.nickName;
    self.ageLabel.text = @"男孩 4岁";
    self.dateLabel.text = data.addTime;
    self.starView.rating = [data.star floatValue];
    
    [self.containerView removeAllSubviews];
    
    // text content
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(0);
        make.left.equalTo(self.containerView).with.offset(0);
        make.right.equalTo(self.containerView).with.offset(0);
        make.bottom.lessThanOrEqualTo(self.containerView).with.offset(bottomPadding);
    }];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:contentFontSize];
    label.lineSpacing = LineSpacing;
    label.text = data.content;
    
    // images
    UIView *lastView = label;
    if (data.imgs && data.imgs.count > 0) {
        UIImageView *lastImage;
        NSNumber *imageSize = [[NSNumber alloc]initWithInt:(SCREEN_WIDTH - 65 - 40) / 3];
        for (int i = 0; i < data.imgs.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [self.containerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(imageSize);
                make.height.equalTo(imageSize);
                
                //                make.right.lessThanOrEqualTo(self.contentView).with.offset(-5);
                make.bottom.lessThanOrEqualTo(self.containerView).with.offset(bottomPadding);
                
                
                if (fmod(i, 3) == 0) {
                    make.left.equalTo(self.containerView).with.offset(0);
                    if (lastImage) {
                        if (i/3 == 0) {
                            make.top.equalTo(lastImage.mas_top).with.offset(0);
                        } else {
                            make.top.equalTo(lastImage.mas_bottom).with.offset(5);
                        }
                        
                    } else {
                        make.top.equalTo(label.mas_bottom).with.offset(12);
                    }
                    
                } else {
                    make.left.equalTo(lastImage.mas_right).with.offset(5);
                    if (lastImage) {
                        make.top.equalTo(lastImage.mas_top).with.offset(0);
                        
                    } else {
                        make.top.equalTo(label.mas_bottom).with.offset(12);
                    }
                }
            }];
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = UIColorFromRGB(0xcccccc);
            [imageView sd_setImageWithURL:[data.imgs objectAtIndex:i]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageClick:)];
            [imageView addGestureRecognizer:singleTap];
            
            lastImage = imageView;
        }
        lastView = lastImage;
    }
    
    if (data.courseTitle.length > 0) {
        // img tag
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.containerView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@12);
            make.height.equalTo(@12);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).with.offset(10);
            } else {
                make.top.equalTo(label.mas_bottom).with.offset(10);
            }
            
            make.left.equalTo(self.containerView).with.offset(0);
            make.bottom.lessThanOrEqualTo(self.containerView).with.offset(bottomPadding);
        }];
        icon.image = [UIImage imageNamed:@"IconReviewTag"];
        
        // text tag
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        [self.containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).with.offset(9);
            } else {
                make.top.equalTo(label.mas_bottom).with.offset(10);
            }
            
            make.left.equalTo(icon.mas_right).with.offset(5);
            make.right.equalTo(self.containerView).with.offset(0);
            make.bottom.lessThanOrEqualTo(self.containerView).with.offset(bottomPadding);
        }];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = data.courseTitle;
    }
}

- (void)onImageClick:(UIGestureRecognizer *)recognizer {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.review.largeImgs.count];
    for (int i = 0; i < self.review.largeImgs.count; i++) {
        NSString *url = self.review.largeImgs[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = (UIImageView *)recognizer.view;
        [photos addObject:photo];
    }
    
    NSInteger index = recognizer.view.tag;
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index;
    browser.photos = photos;
    [browser show];
}

- (IBAction)onUserInfoClicked:(id)sender {
    if (self.review) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://userinfo?uid=%@", self.review.userId]]];
    }
}

@end