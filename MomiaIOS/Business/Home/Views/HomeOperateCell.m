//
//  HomeOperateCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "HomeOperateCell.h"
#import "IndexModel.h"

static const int kItemHeight = 80;

@implementation HomeOperateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(id)model reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        NSArray *items = model;
        CGFloat padding = 10.0;
        CGFloat iconSize = 40.0;
        CGFloat itemWidth = SCREEN_WIDTH / 2;
        for (int i = 0; i < items.count; i++) {
            IndexEvent *event = items[i];
            int row = i / 2;
            int col = fmod(i, 2);
            CGRect frame = CGRectMake(col * itemWidth, row * kItemHeight, itemWidth, kItemHeight);
            UIView *container = [[UIView alloc]initWithFrame:frame];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(itemWidth - padding - iconSize, 2 * padding, iconSize, iconSize)];
            [container addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding * 1.5, itemWidth - iconSize - 2 * padding, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = UIColorFromRGB(0x333333);
            [container addSubview:titleLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding * 1.5 + 30, itemWidth - iconSize - 2 * padding, 20)];
            subTitleLabel.textAlignment = NSTextAlignmentLeft;
            subTitleLabel.font = [UIFont systemFontOfSize:12];
            subTitleLabel.textColor = UIColorFromRGB(0x999999);
            [container addSubview:subTitleLabel];
            
            [self.contentView addSubview:container];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:event.img] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
            titleLabel.text = event.title;
            subTitleLabel.text = event.desc;
        }
        
        int i = items.count;
        int row = i / 2;
        if (fmod(i, 2) != 0) {
            row += 1;
        }
        CGFloat height = row * kItemHeight;
        
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, padding, 0.5, height - 2 * padding)];
        [self.contentView addSubview:verLine];
        verLine.backgroundColor = UIColorFromRGB(0xdddddd);
        
        for (int i = 0; i < row; i ++) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(padding, i * kItemHeight, SCREEN_WIDTH - 2 * padding, 0.5)];
            [self.contentView addSubview:line];
            line.backgroundColor = UIColorFromRGB(0xdddddd);
        }
        
    }
    return self;
}

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model {
    NSArray *items = model;
    int i = items.count;
    int row = i / 2;
    if (fmod(i, 2) != 0) {
        row += 1;
    }
    return row * kItemHeight;
}

@end
