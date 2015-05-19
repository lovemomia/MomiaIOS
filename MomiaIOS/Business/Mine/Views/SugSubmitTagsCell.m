//
//  SugSubmitTagsCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugSubmitTagsCell.h"

@implementation SugSubmitTagsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UITextView *nameTv = [[UITextView alloc]init];
        nameTv.height = 40;
        nameTv.width = SCREEN_WIDTH - 20;
        nameTv.top = 5;
        nameTv.left = 10;
        [nameTv setBackgroundColor:[UIColor clearColor]];
        [self addSubview:nameTv];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellTags";
    SugSubmitTagsCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SugSubmitTagsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 44;
}

@end
