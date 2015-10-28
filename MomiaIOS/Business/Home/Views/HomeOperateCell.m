//
//  HomeOperateCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "HomeOperateCell.h"
#import "IndexModel.h"

static const int kItemHeight = 76;

@interface HomeOperateCell()
@property (nonatomic, strong) NSArray *data;
@end

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
        self.data = model;
        NSArray *colorArray = @[UIColorFromRGB(0xff961b), UIColorFromRGB(0x8cd034), UIColorFromRGB(0x58bfef), UIColorFromRGB(0xfd719a)];
        
        CGFloat padding = 10.0;
        CGFloat iconSize = 45.0;
        CGFloat itemWidth = SCREEN_WIDTH / 2;
        for (int i = 0; i < self.data.count; i++) {
            IndexEvent *event = self.data[i];
            int row = i / 2;
            int col = fmod(i, 2);
            CGRect frame = CGRectMake(col * itemWidth, row * kItemHeight, itemWidth, kItemHeight);
            UIView *container = [[UIView alloc]initWithFrame:frame];
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onItemClicked:)];
            [container addGestureRecognizer:singleTap];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(itemWidth - padding - iconSize, 16, iconSize, iconSize)];
            [container addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding + 3, itemWidth - iconSize - 2 * padding, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            titleLabel.textColor = colorArray[i];
            [container addSubview:titleLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding + 30, itemWidth - iconSize - 2 * padding, 20)];
            subTitleLabel.textAlignment = NSTextAlignmentLeft;
            subTitleLabel.font = [UIFont systemFontOfSize:12];
            subTitleLabel.textColor = UIColorFromRGB(0x666666);
            [container addSubview:subTitleLabel];
            
            [self.contentView addSubview:container];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:event.img]];
            titleLabel.text = event.title;
            subTitleLabel.text = event.desc;
        }
        
        NSInteger i = self.data.count;
        NSInteger row = i / 2;
        if (fmod(i, 2) != 0) {
            row += 1;
        }
        CGFloat height = row * kItemHeight;
        
        UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, 0.5, height)];
        [self.contentView addSubview:verLine];
        verLine.backgroundColor = UIColorFromRGB(0xeeeeee);
        
        for (int i = 1; i < row; i ++) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, i * kItemHeight, SCREEN_WIDTH, 0.5)];
            [self.contentView addSubview:line];
            line.backgroundColor = UIColorFromRGB(0xeeeeee);
        }
        
    }
    return self;
}

- (void)onItemClicked:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    IndexEvent *event = self.data[view.tag];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:event.action]];
}

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model {
    NSArray *items = model;
    NSInteger i = items.count;
    NSInteger row = i / 2;
    if (fmod(i, 2) != 0) {
        row += 1;
    }
    return row * kItemHeight;
}

@end
