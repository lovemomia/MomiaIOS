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
    
    [super sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_user_not_login"]];
}

@end
