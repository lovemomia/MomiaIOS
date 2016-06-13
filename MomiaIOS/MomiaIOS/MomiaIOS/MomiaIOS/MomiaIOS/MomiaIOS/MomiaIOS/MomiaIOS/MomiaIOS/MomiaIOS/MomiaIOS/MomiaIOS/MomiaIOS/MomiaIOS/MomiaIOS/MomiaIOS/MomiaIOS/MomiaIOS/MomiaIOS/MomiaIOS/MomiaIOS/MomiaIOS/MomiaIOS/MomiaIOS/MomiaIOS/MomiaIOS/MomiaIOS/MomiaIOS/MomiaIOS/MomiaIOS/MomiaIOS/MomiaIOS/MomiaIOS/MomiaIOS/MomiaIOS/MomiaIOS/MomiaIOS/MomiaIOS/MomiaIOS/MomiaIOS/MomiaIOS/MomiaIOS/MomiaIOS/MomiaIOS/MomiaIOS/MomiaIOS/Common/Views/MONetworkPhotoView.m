//
//  MONetworkPhotoView.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MONetworkPhotoView.h"
#import "THProgressView.h"

@interface MONetworkPhotoView()
@property (nonatomic, strong) THProgressView *progressView;
@end

@implementation MONetworkPhotoView

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
    
    if (self.progressView == nil) {
        self.progressView = [[THProgressView alloc]init];
        self.progressView.borderTintColor = [UIColor whiteColor];
        self.progressView.progressTintColor = [UIColor whiteColor];
    }
    [self.progressView setProgress:0.0f animated:YES]; // floating-point value between 0.0 and 1.0
    [self addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@20);
        make.center.equalTo(self);
    }];
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat received = [[NSNumber numberWithInteger:receivedSize] floatValue];
        CGFloat expected = [[NSNumber numberWithInteger:expectedSize] floatValue];
        CGFloat progress = (received / expected);
        [self.progressView setProgress:progress animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progressView removeFromSuperview];
    }];
}

@end
