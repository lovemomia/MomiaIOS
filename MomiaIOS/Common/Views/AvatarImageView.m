//
//  AvatarImageView.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AvatarImageView.h"

@implementation AvatarImageView

-(void)sd_setImageWithURL:(NSURL *)url {
    // 圆形
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:85 green:85 blue:85 alpha:1] CGColor];
    
    [super sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"IconUserNotLogin"]];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    // 圆形
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithRed:85 green:85 blue:85 alpha:1] CGColor];
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

@end
