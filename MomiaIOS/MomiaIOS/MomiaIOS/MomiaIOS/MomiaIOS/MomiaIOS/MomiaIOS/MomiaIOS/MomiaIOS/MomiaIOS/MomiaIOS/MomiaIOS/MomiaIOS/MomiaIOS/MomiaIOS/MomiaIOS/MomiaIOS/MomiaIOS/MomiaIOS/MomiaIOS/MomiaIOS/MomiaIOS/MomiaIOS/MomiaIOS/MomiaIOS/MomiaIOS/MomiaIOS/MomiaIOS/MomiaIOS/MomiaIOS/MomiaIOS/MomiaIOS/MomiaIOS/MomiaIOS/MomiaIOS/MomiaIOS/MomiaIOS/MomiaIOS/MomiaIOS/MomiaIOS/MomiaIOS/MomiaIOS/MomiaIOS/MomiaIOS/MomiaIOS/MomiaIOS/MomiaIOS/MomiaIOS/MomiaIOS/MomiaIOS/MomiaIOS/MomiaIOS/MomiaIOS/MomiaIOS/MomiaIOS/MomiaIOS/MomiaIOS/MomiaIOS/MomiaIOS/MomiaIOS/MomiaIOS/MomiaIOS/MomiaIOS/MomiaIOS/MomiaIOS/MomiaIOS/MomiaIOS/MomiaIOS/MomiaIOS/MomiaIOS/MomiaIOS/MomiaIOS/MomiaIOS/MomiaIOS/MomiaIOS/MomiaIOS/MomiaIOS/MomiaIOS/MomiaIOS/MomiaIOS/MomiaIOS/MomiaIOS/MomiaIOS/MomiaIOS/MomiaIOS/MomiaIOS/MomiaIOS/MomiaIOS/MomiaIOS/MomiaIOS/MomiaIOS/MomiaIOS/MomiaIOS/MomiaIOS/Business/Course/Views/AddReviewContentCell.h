//
//  AddReviewContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/4.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface AddReview : JSONModel
@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, strong) NSNumber *bookingId;
@property (nonatomic, strong) NSNumber *star;
@property (nonatomic, strong) NSNumber *teacher;
@property (nonatomic, strong) NSNumber *enviroment;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *imgs;
@end

@protocol ReviewPhotoPickDelegate <NSObject>

-(void)onPhotoViewClick:(UIImageView *)photoView;

@end

@interface AddReviewContentCell : UITableViewCell

@property (assign, nonatomic) int photoCount;

@property (strong, nonatomic) UITextView *contentTv;
@property (strong, nonatomic) UIView *container;

@property(assign,nonatomic)id<ReviewPhotoPickDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGSize)sizeOfImage;

+ (CGFloat)heightWithImageCount:(int)count;

- (UIImageView *)addNextPhotoView;

- (void)setData:(NSString *)content andImages:(NSArray *)images;

@end
