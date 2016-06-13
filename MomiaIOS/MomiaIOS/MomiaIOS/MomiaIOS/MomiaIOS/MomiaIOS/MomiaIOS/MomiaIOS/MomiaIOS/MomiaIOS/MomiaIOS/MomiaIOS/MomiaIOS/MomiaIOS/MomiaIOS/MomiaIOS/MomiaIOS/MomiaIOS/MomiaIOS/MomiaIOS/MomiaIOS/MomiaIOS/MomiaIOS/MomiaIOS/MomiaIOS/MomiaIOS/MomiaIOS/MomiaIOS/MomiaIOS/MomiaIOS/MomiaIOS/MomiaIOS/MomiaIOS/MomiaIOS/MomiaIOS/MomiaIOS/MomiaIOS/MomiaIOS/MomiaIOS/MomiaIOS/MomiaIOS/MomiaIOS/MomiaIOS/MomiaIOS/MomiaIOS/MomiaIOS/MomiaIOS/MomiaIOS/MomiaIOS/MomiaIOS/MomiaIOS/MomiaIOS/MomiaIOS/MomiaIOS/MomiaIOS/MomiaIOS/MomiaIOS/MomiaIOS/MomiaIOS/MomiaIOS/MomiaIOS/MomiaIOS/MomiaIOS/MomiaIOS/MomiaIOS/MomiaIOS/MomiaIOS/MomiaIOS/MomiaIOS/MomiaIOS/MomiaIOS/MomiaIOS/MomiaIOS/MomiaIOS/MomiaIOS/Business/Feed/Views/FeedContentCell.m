//
//  PlaymateContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedContentCell.h"
#import "TTTAttributedLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define LineSpacing 6
#define contentFontSize 13.0f

@interface FeedContentCell()
@property (nonatomic, strong) Feed *feed;
@end

@implementation FeedContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView contentModel:(Feed *)model {
    self.feed = model;
    if (self = [super init]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        UIView *lastView;
        
        // text content
        if (model.content.length > 0) {
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).with.offset(12);
                make.left.equalTo(self.contentView).with.offset(65);
                make.right.equalTo(self.contentView).with.offset(-10);
                make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
            }];
            label.numberOfLines = 0;
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:contentFontSize];
            label.lineSpacing = LineSpacing;
            
            NSString *text = model.content;
            NSArray *tagIndexs = [self indexForTag:@"#" inText:text];
            if (tagIndexs.count > 1) {
                [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange boldRange = NSMakeRange([[tagIndexs objectAtIndex:0] integerValue],[[tagIndexs objectAtIndex:1] integerValue] - 2);
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:MO_APP_ThemeColor range:boldRange];
                    
                    return mutableAttributedString;
                }];
                
            } else {
                label.text = text;
            }
            
            lastView = label;
        }
        
        // images
        // TODO autolayout warning!
        
        if (model.imgs && model.imgs.count > 0) {
            UIImageView *lastImage;
            NSNumber *imageSize = [[NSNumber alloc]initWithInt:(SCREEN_WIDTH - 65 - 40) / 3];
            for (int i = 0; i < model.imgs.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]init];
                [self.contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(imageSize);
                    make.height.equalTo(imageSize);
                    
                    //                make.right.lessThanOrEqualTo(self.contentView).with.offset(-5);
                    make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
                    
                    
                    if (fmod(i, 3) == 0) {
                        make.left.equalTo(self.contentView).with.offset(65);
                        if (lastImage) {
                            if (i/3 == 0) {
                                make.top.equalTo(lastImage.mas_top).with.offset(0);
                            } else {
                                make.top.equalTo(lastImage.mas_bottom).with.offset(5);
                            }
                            
                        } else {
                            make.top.equalTo(lastView ? lastView.mas_bottom : self.contentView).with.offset(12);
                        }
                        
                    } else {
                        make.left.equalTo(lastImage.mas_right).with.offset(5);
                        if (lastImage) {
                            make.top.equalTo(lastImage.mas_top).with.offset(0);
                            
                        } else {
                            make.top.equalTo(lastView ? lastView.mas_bottom : self.contentView).with.offset(12);
                        }
                    }
                }];
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                imageView.backgroundColor = UIColorFromRGB(0xcccccc);
                [imageView sd_setImageWithURL:[model.imgs objectAtIndex:i]];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageClick:)];
                [imageView addGestureRecognizer:singleTap];
                
                lastImage = imageView;
            }
            lastView = lastImage;
        }
        
        if (model.tagName.length > 0) {
            // img tag
            UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@12);
                make.height.equalTo(@12);
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(10);
                } else {
                    make.top.equalTo(self.contentView).with.offset(10);
                }
                
                make.left.equalTo(self.contentView).with.offset(65);
                make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-10);
            }];
            icon.image = [UIImage imageNamed:@"IconReviewTag"];
            
            // text tag
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(9);
                } else {
                    make.top.equalTo(label.mas_bottom).with.offset(10);
                }
                
                make.left.equalTo(icon.mas_right).with.offset(5);
                make.right.equalTo(self.contentView).with.offset(0);
                make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-10);
            }];
            label.numberOfLines = 0;
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont systemFontOfSize:12.0f];
            label.text = model.tagName;
        }
        
        // location
        
    }
    return self;
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

- (void)onImageClick:(UIGestureRecognizer *)recognizer {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.feed.imgs.count];
    for (int i = 0; i < self.feed.largeImgs.count; i++) {
        NSString *url = [self.feed.largeImgs objectAtIndex:i];
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

+ (CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(Feed *)model {
    FeedContentCell * cell = [[FeedContentCell alloc] initWithTableView:tableView contentModel:model];
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    
    
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed value.
    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }
    
    CGSize fittingSize = CGSizeZero;
    
    
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:cell.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:contentViewWidth];
    [cell.contentView addConstraint:tempWidthConstraint];
    
    
    // Auto layout engine does its math
    fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [cell.contentView removeConstraint:tempWidthConstraint];
    
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingSize.height;
}

@end
