//
//  HomeGridCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "HomeGridCell.h"
#import "IndexModel.h"

static const int kItemHeight = 80;

@interface HomeGridCell()
@property (nonatomic, strong) NSArray *data;
@end

@implementation HomeGridCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(id)model reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]) {
        self.data = model;
        CGFloat padding = 10.0;
        CGFloat iconSize = 50.0;
        CGFloat itemWidth = (SCREEN_WIDTH - 20) / 4;
        for (int i = 0; i < self.data.count; i++) {
            IndexIcon *icon = self.data[i];
            int row = i / 4;
            int col = i < 4 ? i : (i - 4);
            CGRect frame = CGRectMake(padding + col * itemWidth, (row + 1) * padding + row * kItemHeight, iconSize, iconSize);
            UIView *container = [[UIView alloc]initWithFrame:frame];
            container.tag = i;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onItemClicked:)];
            [container addGestureRecognizer:singleTap];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(itemWidth/2 - iconSize/2, 0, iconSize, iconSize)];
            [container addSubview:imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, iconSize + 5, itemWidth, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = UIColorFromRGB(0x333333);
            [container addSubview:label];
            
            [self.contentView addSubview:container];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:icon.img] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
            label.text = icon.title;
        }
    }
    return self;
}

- (void)onItemClicked:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    IndexIcon *icon = self.data[view.tag];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:icon.action]];
}

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model {
    NSArray *items = model;
    int i = items.count;
    int row = i / 4;
    if (fmod(i, 4) != 0) {
        row += 1;
    }
    return (row + 1) * 10 + (row) * kItemHeight;
}


@end
