//
//  SugSubmitProductContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductPhotoPickDelegate <NSObject>

-(void)onPhotoViewClick:(UIImageView *)photoView;

@end

@interface SugSubmitProductContentCell : UITableViewCell

@property(assign,nonatomic)id<ProductPhotoPickDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)height;

- (UIImageView *)addNextPhotoView;

@end
