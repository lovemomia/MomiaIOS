//
//  CourseDiscCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseDiscCell.h"
#import "TTTAttributedLabel.h"
#import "Package.h"

@implementation CourseDiscCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(Package *)model reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        TTTAttributedLabel *label = [TTTAttributedLabel new];
        label.numberOfLines = 0;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        label.lineSpacing = 6;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        
        label.text = model.intro;
    }
    return self;
}

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model {
    CourseDiscCell * cell = [[CourseDiscCell alloc] initWithTableView:tableView forModel:model reuseIdentifier:@"CourseDiscCell"];
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
