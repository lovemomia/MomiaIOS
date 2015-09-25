//
//  AddFeedContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "AddFeedContentCell.h"

#define CONTENT_INPUT_HEIGHT         115
#define IMAGE_LIMITE                 9

@interface AddFeedContentCell()
@property (nonatomic, strong) NSArray *images;
@end

@implementation AddFeedContentCell
@synthesize contentTv;
@synthesize container;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGSize)sizeOfImage {
    CGFloat width = (SCREEN_WIDTH - 60)/4;
    return CGSizeMake(width, width);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_INPUT_HEIGHT)];
        
        contentTv = [[UITextView alloc]init];
        contentTv.returnKeyType = UIReturnKeyDone;
        [contentTv addPlaceHolder:@"说说参加活动的感受吧..."];
        contentTv.height = CONTENT_INPUT_HEIGHT - 15;
        contentTv.width = SCREEN_WIDTH - 20;
        contentTv.top = 5;
        contentTv.left = 8;
        [contentTv setFont:[UIFont systemFontOfSize:15]];
        contentTv.placeHolderTextView.font = [UIFont systemFontOfSize:15];
        
        [contentTv setBackgroundColor:[UIColor clearColor]];
        [container addSubview:contentTv];
        [self addSubview:container];
    }
    return self;
}

- (void)setData:(NSString *)content andImages:(NSArray *)images {
    [container removeAllSubviews];
    self.photoCount = 0;
    // content
    if (self.contentTv == nil) {
        contentTv = [[UITextView alloc]init];
        contentTv.returnKeyType = UIReturnKeyDone;
        [contentTv addPlaceHolder:@"说说参加活动的感受吧..."];
        contentTv.height = CONTENT_INPUT_HEIGHT - 15;
        contentTv.width = SCREEN_WIDTH - 20;
        contentTv.top = 5;
        contentTv.left = 8;
        [contentTv setFont:[UIFont systemFontOfSize:15]];
        contentTv.placeHolderTextView.font = [UIFont systemFontOfSize:15];
        
        [contentTv setBackgroundColor:[UIColor clearColor]];
    } else {
        [self.contentTv removeFromSuperview];
    }
    self.contentTv.text = content;
    [container addSubview:contentTv];
    
    // images
    CGFloat photoHeight = (SCREEN_WIDTH - 60)/4;
    for (int i = 0; i < images.count; i++) {
        SelectImage *image = images[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        // image frame
        int cloumn = fmod(i, 4);
        int row = i / 4;
        imageView.frame = CGRectMake(15 + cloumn * (photoHeight + 10), CONTENT_INPUT_HEIGHT + (photoHeight + 10) * row, photoHeight, photoHeight);
        
        // click
        imageView.userInteractionEnabled=YES;
        imageView.tag = i;
        imageView.image = image.thumb;
        
        [container addSubview:imageView];
        self.photoCount ++;
    }
    [self addNextPhotoView];
    container.height = [AddFeedContentCell heightWithImageCount:(self.photoCount)];
}

- (UIImageView *)addNextPhotoView {
    if (self.photoCount < IMAGE_LIMITE) {
        return [self addSelectPhotoViewAtIndex:self.photoCount];
    }
    return nil;
}

- (UIImageView *)addSelectPhotoViewAtIndex:(int)index {
    CGFloat photoHeight = (SCREEN_WIDTH - 60)/4;
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    // image frame
    int cloumn = fmod(index, 4);
    int row = index / 4;
    imageView.frame = CGRectMake(15 + cloumn * (photoHeight + 10), CONTENT_INPUT_HEIGHT + (photoHeight + 10) * row, photoHeight, photoHeight);
    
    // click
    imageView.userInteractionEnabled=YES;
    imageView.tag = -1;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [imageView addGestureRecognizer:singleTap];
    imageView.image = [UIImage imageNamed:@"IconUploadImage"];
    
    [container addSubview:imageView];

    return imageView;
}

- (void)onClickImage:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.delegate && imageView.tag == -1) {
        [self.delegate onPhotoViewClick:(UIImageView *)(tap.view)];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellContent";
    AddFeedContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddFeedContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)heightWithImageCount:(int)count {
    int row = count / 4;
    CGFloat photoHeight = (SCREEN_WIDTH - 60)/4;
    CGFloat height = CONTENT_INPUT_HEIGHT + (photoHeight + 10) * (row + 1);
    return height;
}
@end
