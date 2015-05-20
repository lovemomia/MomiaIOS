//
//  SugSubmitProductCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugSubmitProductNameCell.h"
#import "UITextView+Placeholder.h"


@implementation SugSubmitProductNameCell
@synthesize nameTv;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        nameTv = [[UITextView alloc]init];
        [nameTv addPlaceHolder:@"请输入商品名"];
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
    static NSString *identifier = @"CellName";
    SugSubmitProductNameCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SugSubmitProductNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 50;
}

@end
