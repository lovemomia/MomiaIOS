//
//  CoursePriceCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CoursePriceCell.h"
#import "StringUtils.h"
#import "Course.h"

@implementation CoursePriceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Course *)data {
    if ((data.type && [data.type intValue] == 1) || (data.type == nil && data.price == 0)) {
        self.priceLabel.text = @"公益课";
        self.priceLabel.font = [UIFont systemFontOfSize:16];
        self.price1Label.text = @"";
        self.price2Label.text = @"";
        self.price3Label.text = @"";
        
    } else if ([data.buyable intValue] == 1) {
        self.priceLabel.hidden = YES;
        self.price1Label.hidden = YES;
        self.price2Label.hidden = YES;
        self.price3Label.hidden = YES;
        
    } else {
        self.priceLabel.text = [StringUtils stringForPrice:data.price];
    }
    
    for (UIView * view in self.tagsContainer.subviews) {
        if([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView * lastView;
    int tagCount;
    if (data.insurance && [data.insurance boolValue]) {
        tagCount = 2;
    } else {
        tagCount = 1;
    }
    for (int i = 0; i < tagCount; i++) {
        UIImageView * imgView = [[UIImageView alloc] init];
        [self.tagsContainer addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagsContainer).with.offset(2);
            if(i == 0) make.leading.equalTo(self.tagsContainer).with.offset(10);
            else make.leading.equalTo(lastView.mas_trailing).with.offset(8);
            make.width.equalTo(@17);
            make.height.equalTo(@17);
        }];
        [imgView setImage:[UIImage imageNamed:@"IconProductTag"]];
        
        UILabel * label = [[UILabel alloc] init];
        [self.tagsContainer addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tagsContainer).with.offset(2);
            make.leading.equalTo(imgView.mas_trailing).with.offset(2);
        }];
        
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"%@", data.age];
        } else if (i == 1) {
            label.text = @"送保险";
        }
        
        label.textColor = MO_APP_ThemeColor;
        label.font = [UIFont systemFontOfSize:13.0f];
        
        lastView = label;
    }
    
    NSNumber *joined = data.joined;
    if (joined == nil || [joined intValue] == 0) {
        return;
    }
    
    // joined
    UIImageView * imgView = [[UIImageView alloc] init];
    [self.tagsContainer addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tagsContainer).with.offset(2);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.left.equalTo(lastView.mas_right).with.offset(8);
    }];
    [imgView setImage:[UIImage imageNamed:@"IconProductTag"]];
    
    UILabel * label = [[UILabel alloc] init];
    [self.tagsContainer addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tagsContainer).with.offset(2);
        make.left.equalTo(imgView.mas_right).with.offset(2);
    }];
    label.text = [NSString stringWithFormat:@"%@人已参加", joined];
    label.textColor = MO_APP_ThemeColor;
    label.font = [UIFont systemFontOfSize:13.0f];

}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 50;
}

@end
