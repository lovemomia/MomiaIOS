//
//  SugSubmitProductContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugSubmitProductContentCell.h"

@interface SugSubmitProductContentCell()

@property (assign, nonatomic) int photoViewCount;

@end

@implementation SugSubmitProductContentCell
@synthesize contentTv;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        contentTv = [[UITextView alloc]init];
        contentTv.returnKeyType = UIReturnKeyDone;
        [contentTv addPlaceHolder:@"说说你的使用心得吧..."];
        contentTv.height = 100;
        contentTv.width = SCREEN_WIDTH - 20;
        contentTv.top = 5;
        contentTv.left = 10;
        [contentTv setFont:[UIFont systemFontOfSize:16]];
        contentTv.placeHolderTextView.font = [UIFont systemFontOfSize:16];
        
        [self addPhotoViewAtIndex:0];
        
        [contentTv setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentTv];
    }
    return self;
}

- (UIImageView *)addNextPhotoView {
    if (self.photoViewCount < 3) {
        return [self addPhotoViewAtIndex:self.photoViewCount];
    }
    return nil;
}

- (UIImageView *)addPhotoViewAtIndex:(int)index {
    CGFloat photoHeight = (SCREEN_WIDTH - 50)/4;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(10 + index * (photoHeight + 10), 115, photoHeight, photoHeight);
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    // click
    imageView.userInteractionEnabled=YES;
    imageView.tag = index;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [imageView addGestureRecognizer:singleTap];
    imageView.image = [UIImage imageNamed:@"suggest_add"];
    
    [self addSubview:imageView];
    self.photoViewCount ++;
    return imageView;
}

- (void)onClickImage:(UITapGestureRecognizer *)tap {
    if (self.delegate && tap.view.tag == self.photoViewCount - 1) {
        [self.delegate onPhotoViewClick:(UIImageView *)(tap.view)];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellContent";
    SugSubmitProductContentCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SugSubmitProductContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 110 + (SCREEN_WIDTH - 50)/4 + 15;
}

@end
