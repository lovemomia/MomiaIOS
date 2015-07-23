//
//  PlaymateContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateContentCell.h"
#import "TTTAttributedLabel.h"

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
            make.left.equalTo(self.contentView).with.offset(65);
            make.top.equalTo(self.contentView).with.offset(12);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
        }];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:contentFontSize];
        label.lineSpacing = LineSpacing;
        label.text = @"参加了#来哆啦a梦家，参观密室逃脱#活动不错，大朋友和小朋友都很投入，我家小宝很开心，下次如果能按年龄分组就更好了...";
        
        // images
        
        
        
        // location
        
    }
    return self;
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
