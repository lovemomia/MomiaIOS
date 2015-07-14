//
//  ProductDetailContentCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/2.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailContentCell.h"
#import "ProductModel.h"
#import "TTTAttributedLabel.h"

#define TopMargin 19
#define LineSpacing 13
#define ImgScale 0.75

@implementation ProductDetailContentCell

-(instancetype)initWithTableView:(UITableView *) tableView contentModel:(ProductContentModel *)model;
{
    self = [super init];
    if(self) {
        UILabel * titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(TopMargin);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
        }];
        titleLabel.numberOfLines = 1;
        titleLabel.text = model.title;
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIView * lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = tableView.separatorColor;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).with.offset(TopMargin);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
            make.height.equalTo(@0.5);
        }];
        
        UIView * lastView = lineView;
        
        __block BOOL firstText = YES;
        
        for(int i = 0; i < model.body.count; i++) {
            ProductBodyModel * bodyModel = model.body[i];
            if(bodyModel.link) {
                
                firstText = YES;
                
                UIView * linkView = [[UIView alloc] init];
                linkView.tag = i;
                [self.contentView addSubview:linkView];
                
                [linkView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                    make.left.bottom.and.right.equalTo(self.contentView);
                    make.height.equalTo(@52);
                }];
                
                UIView * lineView = [[UIView alloc] init];
                [linkView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(linkView).with.offset(0);
                    make.left.equalTo(linkView).with.offset(10);
                    make.right.equalTo(linkView).with.offset(0);
                    make.height.equalTo(@0.5);
                }];
                lineView.backgroundColor = tableView.separatorColor;
                
                UILabel * label = [[UILabel alloc] init];
                [linkView addSubview:label];
                
                UIImageView * goImgView = [[UIImageView alloc] init];
                [linkView addSubview:goImgView];
                
                [goImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(linkView);
                    make.right.equalTo(linkView).with.offset(-10);
                    make.width.equalTo(@7);
                    make.height.equalTo(@13);
                }];
                [goImgView setImage:[UIImage imageNamed:@"cm_go"]];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(linkView);
                    make.left.equalTo(linkView).with.offset(10);
                    make.right.equalTo(goImgView.mas_left).with.offset(-5);
                }];
                label.numberOfLines = 1;
                label.text = bodyModel.text;
                label.textColor = UIColorFromRGB(0x999999);
                label.font = [UIFont systemFontOfSize:14];
                
                UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLinkClick:)];
                [linkView addGestureRecognizer:singleTap];
                
                lastView = linkView;
                
            } else if(bodyModel.img) {
                
                firstText = YES;
                
                UIImageView * imgView = [[UIImageView alloc] init];
                [self.contentView addSubview:imgView];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                    make.left.equalTo(self.contentView).with.offset(10);
                    make.right.equalTo(self.contentView).with.offset(-10);
                    make.height.equalTo(@((SCREEN_WIDTH - 20) * ImgScale));
                    make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                }];
                [imgView sd_setImageWithURL:[NSURL URLWithString:bodyModel.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                
                lastView = imgView;
                
                
            } else {
                if(bodyModel.label) {
                    UILabel * label = [[UILabel alloc] init];
                    [self.contentView addSubview:label];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        if(firstText) {
                            make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                            firstText = NO;
                        } else {
                            make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                        }
                        make.left.equalTo(self.contentView).with.offset(10);
                        make.right.equalTo(self.contentView).with.offset(-10);
                        make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                    }];
                    label.numberOfLines = 1;
                    label.textColor = UIColorFromRGB(0x999999);
                    label.text = bodyModel.label;
                    label.font = [UIFont systemFontOfSize:13];
                    lastView = label;
                }
                if(bodyModel.text) {
                    if([model.style isEqualToString:@"none"]) {
                        TTTAttributedLabel * label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                        [self.contentView addSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            if(firstText) {
                                make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                                firstText = NO;
                            } else {
                                make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                            }
                            
                            make.left.equalTo(self.contentView).with.offset(10);
                            make.right.equalTo(self.contentView).with.offset(-10);
                            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                        }];
                        label.numberOfLines = 0;
                        label.textColor = UIColorFromRGB(0x333333);
                        label.font = [UIFont systemFontOfSize:13];
                        label.lineSpacing = LineSpacing;
                        label.text = bodyModel.text;
                        
                        lastView = label;
                        /*
                        UILabel * label = [[UILabel alloc] init];
                        [self.contentView addSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            if(firstText) {
                                make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                                firstText = NO;
                            } else {
                                make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                            }

                            make.left.equalTo(self.contentView).with.offset(10);
                            make.right.equalTo(self.contentView).with.offset(-10);
                            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                        }];
                        label.numberOfLines = 0;
                        
                        NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:bodyModel.text];
                        [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, as.length)];
                        [as addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, as.length)];
                        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = LineSpacing;
                        [as addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, as.length)];
                        label.attributedText = as;
                        
                        lastView = label;*/
                        
                    } else {
                        UILabel * shortLabel = [[UILabel alloc] init];
                        [self.contentView addSubview:shortLabel];
                        [shortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            if(firstText) {
                                make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                            } else {
                                make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                            }
                            
                            make.left.equalTo(self.contentView).with.offset(10);
                            make.width.equalTo(@10);
                            make.height.equalTo(@12);
                        }];
                        shortLabel.numberOfLines = 1;
                        shortLabel.text = @"-";
                        shortLabel.textColor = UIColorFromRGB(0x333333);
                        
                        TTTAttributedLabel * label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
                        [self.contentView addSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            if(firstText) {
                                make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                                firstText = NO;
                            } else {
                                make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                            }
                            
                            make.left.equalTo(shortLabel.mas_right).with.offset(5);
                            make.right.equalTo(self.contentView).with.offset(-10);
                            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                        }];
                        label.numberOfLines = 0;
                        label.textColor = UIColorFromRGB(0x333333);
                        label.font = [UIFont systemFontOfSize:13];
                        label.lineSpacing = LineSpacing;
                        label.text = bodyModel.text;
                       
                        lastView = label;
                        
                        /*
                        UILabel * label = [[UILabel alloc] init];
                        [self.contentView addSubview:label];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            if(firstText) {
                                make.top.equalTo(lastView.mas_bottom).with.offset(TopMargin);
                                firstText = NO;
                            } else {
                                make.top.equalTo(lastView.mas_bottom).with.offset(LineSpacing);
                            }

                            make.left.equalTo(shortLabel.mas_right).with.offset(5);
                            make.right.equalTo(self.contentView).with.offset(-10);
                            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-TopMargin);
                        }];
                        label.numberOfLines = 0;
                        NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:bodyModel.text];
                        [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, as.length)];
                        [as addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, as.length)];
                        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = LineSpacing;
                        [as addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, as.length)];
                        label.attributedText = as;
                        
                        lastView = label;*/
                    }
                }
            }
        }
    }
    return self;
}

-(void)onLinkClick:(UITapGestureRecognizer *)recognizer
{
    UIView * linkView = recognizer.view;
    self.linkBlock(linkView);
}


+(CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(ProductContentModel *)model
{
    ProductDetailContentCell * cell = [[ProductDetailContentCell alloc] initWithTableView:tableView contentModel:model];
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
