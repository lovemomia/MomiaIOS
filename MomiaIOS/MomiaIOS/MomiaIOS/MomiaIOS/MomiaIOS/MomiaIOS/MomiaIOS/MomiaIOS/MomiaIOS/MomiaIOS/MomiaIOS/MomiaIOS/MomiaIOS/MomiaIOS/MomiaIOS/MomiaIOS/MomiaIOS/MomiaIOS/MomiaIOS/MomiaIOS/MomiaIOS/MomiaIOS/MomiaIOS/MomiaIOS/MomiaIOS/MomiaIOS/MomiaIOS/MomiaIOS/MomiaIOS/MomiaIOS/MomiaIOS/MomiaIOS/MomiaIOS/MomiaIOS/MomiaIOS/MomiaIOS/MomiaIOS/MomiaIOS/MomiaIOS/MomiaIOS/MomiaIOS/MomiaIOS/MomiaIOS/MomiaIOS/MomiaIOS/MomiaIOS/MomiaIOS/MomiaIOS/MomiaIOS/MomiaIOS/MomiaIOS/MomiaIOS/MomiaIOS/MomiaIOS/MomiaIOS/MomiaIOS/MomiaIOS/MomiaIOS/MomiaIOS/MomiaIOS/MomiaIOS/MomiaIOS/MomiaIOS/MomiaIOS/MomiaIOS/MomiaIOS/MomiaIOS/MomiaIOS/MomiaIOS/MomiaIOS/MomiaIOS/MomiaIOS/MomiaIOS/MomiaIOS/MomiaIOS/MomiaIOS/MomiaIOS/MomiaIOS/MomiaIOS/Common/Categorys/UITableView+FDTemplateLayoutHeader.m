//
//  UITableView+FDTemplateLayoutHeader.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "UITableView+FDTemplateLayoutHeader.h"

@implementation UITableView (FDTemplateLayoutHeader)

- (CGFloat)fd_heightForHeaderViewWithIdentifier:(NSString *)identifier configuration:(void (^)(id headerView))configuration
{
    if (!identifier) {
        return 0;
    }
    
    // Fetch a cached template cell for `identifier`.
    UITableViewHeaderFooterView *header;
    header = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    NSAssert(header != nil, @"header must be registered to table view for identifier - %@", identifier);
    header.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Manually calls to ensure consistent behavior with actual cells (that are displayed on screen).
    [header prepareForReuse];
    
    // Customize and provide content for our template cell.
    if (configuration) {
        configuration(header);
    }
    
    
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed value.
    
    CGSize fittingSize = CGSizeZero;
    
    // If auto layout enabled, cell's contentView must have some constraints.
    BOOL autoLayoutEnabled = header.constraints.count > 0;
    if (autoLayoutEnabled) {
        
        // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
        // of growing horizontally, in a flow-layout manner.
        NSLayoutConstraint *tempWidthConstraint =
        [NSLayoutConstraint constraintWithItem:header
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:contentViewWidth];
        [header addConstraint:tempWidthConstraint];
        // Auto layout engine does its math
        fittingSize = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [header removeConstraint:tempWidthConstraint];
        
    }
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
//    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
//        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
//    }
    
    return fittingSize.height;
}


@end
