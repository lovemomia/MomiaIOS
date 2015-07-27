//
//  PlaymateContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateContentCell.h"
#import "TTTAttributedLabel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define LineSpacing 6
#define contentFontSize 13.0f

@implementation PlaymateContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView contentModel:(PlaymateFeed *)model {
    if (self = [super init]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        // text content
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
        
        NSString *text = @"参加了#来哆啦a梦家，参观密室逃脱#活动不错，大朋友和小朋友都很投入，我家小宝很开心，下次如果能按年龄分组就更好了...";
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
        
        // images
        NSNumber *imageSize = [[NSNumber alloc]initWithInt:(SCREEN_WIDTH - 65 - 40) / 3];
        UIImageView *lastImage;
        for (int i = 0; i < 5; i++) {
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
            [imageView sd_setImageWithURL:@"http://maitian.qiniudn.com/dc530090-faef-42a1-85ed-c82f8d0e2610.jpg?imageView2/1/w/240/h/180/q/80/format/jpg"];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onImageClick:)];
            [imageView addGestureRecognizer:singleTap];
            
            lastImage = imageView;
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
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSString *url = @"http://maitian.qiniudn.com/dc530090-faef-42a1-85ed-c82f8d0e2610.jpg?imageView2/1/w/240/h/180/q/80/format/jpg";
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

+ (CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(PlaymateFeed *)model {
    PlaymateContentCell * cell = [[PlaymateContentCell alloc] initWithTableView:tableView contentModel:model];
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
