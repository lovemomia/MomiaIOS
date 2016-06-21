//
//  AddFeedContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFeed.h"
#import "SelectImage.h"

@protocol FeedPhotoPickDelegate <NSObject>

-(void)onPhotoViewClick:(UIImageView *)photoView;

@end

@interface AddFeedContentCell : UITableViewCell

@property (assign, nonatomic) int photoCount;

@property (strong, nonatomic) UITextView *contentTv;
@property (strong, nonatomic) UIView *container;

@property(assign,nonatomic)id<FeedPhotoPickDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGSize)sizeOfImage;

+ (CGFloat)heightWithImageCount:(int)count;

- (UIImageView *)addNextPhotoView;

- (void)setData:(NSString *)content andImages:(NSArray *)images;

@end
