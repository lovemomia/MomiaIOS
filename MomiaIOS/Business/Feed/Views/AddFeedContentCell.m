//
//  AddFeedContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "AddFeedContentCell.h"

#define LineSpacing 6
#define contentFontSize 13.0f

@interface AddFeedContentCell()
@property (nonatomic, strong) AddFeed *feed;
@end

@implementation AddFeedContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView contentModel:(AddFeed *)model {
    self.feed = model;
    if (self = [super init]) {
        // text content
        UITextView *input = [[UITextView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:input];
        [input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@70);
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        input.textColor = UIColorFromRGB(0x333333);
        input.font = [UIFont systemFontOfSize:contentFontSize];
        
        [input addPlaceHolder:@"说说参加活动的感受吧..."];
        input.text = model.baseFeed.content;
        
        NSMutableArray *images = [[NSMutableArray alloc]initWithArray:model.imgs];
        if (!model.imgs || (model.imgs && model.imgs.count < 9)) {
            [images addObject:[[UploadImageData alloc]init]];
        }
        NSNumber *imageSize = [[NSNumber alloc]initWithInt:(SCREEN_WIDTH - 50) / 4];
        UIImageView *lastImage;
        for (int i = 0; i < model.imgs.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(imageSize);
                make.height.equalTo(imageSize);
                
                make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-10);
                
                if (fmod(i, 4) == 0) {
                    make.left.equalTo(self.contentView).with.offset(10);
                    if (lastImage) {
                        if (i/4 == 0) {
                            make.top.equalTo(lastImage.mas_top).with.offset(0);
                        } else {
                            make.top.equalTo(lastImage.mas_bottom).with.offset(10);
                        }
                        
                    } else {
                        make.top.equalTo(input.mas_bottom).with.offset(10);
                    }
                    
                } else {
                    make.left.equalTo(lastImage.mas_right).with.offset(10);
                    if (lastImage) {
                        make.top.equalTo(lastImage.mas_top).with.offset(0);
                        
                    } else {
                        make.top.equalTo(input.mas_bottom).with.offset(10);
                    }
                }
            }];
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.backgroundColor = UIColorFromRGB(0xcccccc);
            UploadImageData *data = [images objectAtIndex:i];
            if (data.path) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:data.path]];
            } else {
                [imageView setImage:[UIImage imageNamed:@"IconUploadImage"]];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onChooseImage:)];
                [imageView addGestureRecognizer:singleTap];
            }
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            
            lastImage = imageView;
        }
    }
    return self;
}

- (void)onChooseImage:(UITapGestureRecognizer *)tap {
    
}

+ (CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(AddFeed *)model {
    AddFeedContentCell * cell = [[AddFeedContentCell alloc] initWithTableView:tableView contentModel:model];
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
