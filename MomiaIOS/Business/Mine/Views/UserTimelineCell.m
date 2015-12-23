//
//  UserTimelineCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "UserTimelineCell.h"
#import "UserTimelineModel.h"
#import "TTTAttributedLabel.h"
#import "EDStarRating.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface UserTimelineCell()
@property (nonatomic, strong) UserTimelineItem *timelineItem;
@end

@implementation UserTimelineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(UserTimelineItem *)data {
    self.timelineItem = data;
    self.dateLabel.text = data.time;
    
    NSString *text = [NSString stringWithFormat:@"参加了课程 #%@#", data.courseTitle];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00c49d) range:NSMakeRange(6, (text.length - 6))];
    NSMutableParagraphStyle * linePadding = [[NSMutableParagraphStyle alloc] init];
    [linePadding setLineSpacing:6];
    [str addAttribute:NSParagraphStyleAttributeName value:linePadding range:NSMakeRange(0, [text length])];
    self.contentLabel.attributedText = str;
    
    [self.reviewContainer removeAllSubviews];
    
    if (data.comment) {
        // rating
        EDStarRating *starView = [[EDStarRating alloc]initWithFrame:CGRectMake(-4, 8, 95, 17)];
        [self.reviewContainer addSubview:starView];
        starView.backgroundColor = [UIColor clearColor];
        starView.starImage = [UIImage imageNamed:@"IconSmallGrayStar"];
        starView.starHighlightedImage = [UIImage imageNamed:@"IconSmallRedStar"];
        starView.maxRating = 5.0;
        starView.horizontalMargin = 12;
        starView.editable = NO;
        starView.displayMode = EDStarRatingDisplayFull;
        starView.rating = [data.comment.star floatValue];
        
        UIView *lastView = starView;
        // text content
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        [self.reviewContainer addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(starView.mas_bottom).with.offset(8);
            make.left.equalTo(self.reviewContainer).with.offset(10);
            make.right.equalTo(self.reviewContainer).with.offset(8);
            make.bottom.lessThanOrEqualTo(self.reviewContainer).with.offset(-8);
        }];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        label.lineSpacing = 6;
        label.text = data.comment.content;
        
        // images
        lastView = label;
        if (data.comment.imgs && data.comment.imgs.count > 0) {
            UIImageView *lastImage;
            NSNumber *imageSize = [[NSNumber alloc]initWithInt:(self.reviewContainer.width - 36) / 3];
            for (int i = 0; i < data.comment.imgs.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]init];
                [self.reviewContainer addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(imageSize);
                    make.height.equalTo(imageSize);
                    
                    make.bottom.lessThanOrEqualTo(self.reviewContainer).with.offset(-10);
                    
                    
                    if (fmod(i, 3) == 0) {
                        make.left.equalTo(self.reviewContainer).with.offset(10);
                        if (lastImage) {
                            if (i/3 == 0) {
                                make.top.equalTo(lastImage.mas_top).with.offset(0);
                            } else {
                                make.top.equalTo(lastImage.mas_bottom).with.offset(-8);
                            }
                            
                        } else {
                            make.top.equalTo(lastView.mas_bottom).with.offset(8);
                        }
                        
                    } else {
                        make.left.equalTo(lastImage.mas_right).with.offset(8);
                        if (lastImage) {
                            make.top.equalTo(lastImage.mas_top).with.offset(0);
                            
                        } else {
                            make.top.equalTo(lastView.mas_bottom).with.offset(8);
                        }
                    }
                }];
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                imageView.backgroundColor = UIColorFromRGB(0xcccccc);
                [imageView sd_setImageWithURL:[data.comment.imgs objectAtIndex:i]];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageClick:)];
                [imageView addGestureRecognizer:singleTap];
                
                lastImage = imageView;
            }
            lastView = lastImage;
        }
    }
}

- (void)onImageClick:(UIGestureRecognizer *)recognizer {
    Review *review = self.timelineItem.comment;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:review.largeImgs.count];
    for (int i = 0; i < review.largeImgs.count; i++) {
        NSString *url = review.largeImgs[i];
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

- (NSArray *)indexForTag:(NSString *)tag inText:(NSString *)text {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i =0; i < [text length]; i++)
    {
        NSString *temp = [text substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:tag]) {
            [array addObject:[[NSNumber alloc] initWithInt:i]];
        }
    }
    return array;
}

- (IBAction)onCourseClicked:(id)sender {
    if (self.timelineItem) {
        NSString *url = [NSString stringWithFormat:@"coursedetail?id=%@", self.timelineItem.courseId];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
    }
}
@end
