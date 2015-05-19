//
//  SugSubmitProductContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugSubmitProductContentCell.h"
#import "UITextView+Placeholder.h"

@interface SugSubmitProductContentCell()

@property (strong, nonatomic) UITextView *nameTv;

@property (assign, nonatomic) int photoViewCount;

@end

@implementation SugSubmitProductContentCell
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
        nameTv.returnKeyType = UIReturnKeyDone;
        [nameTv addPlaceHolder:@"说说你的使用心得吧..."];
        nameTv.height = 100;
        nameTv.width = SCREEN_WIDTH - 20;
        nameTv.top = 5;
        nameTv.left = 10;
        
        [self addPhotoViewAtIndex:0];
        
        [nameTv setBackgroundColor:[UIColor clearColor]];
        [self addSubview:nameTv];
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
    [imageView setBackgroundColor:[UIColor blueColor]];
    
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
