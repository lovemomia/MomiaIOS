//
//  ThirdShareHelper.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ThirdShareHelper.h"

@implementation ThirdShareHelper

- (void)shareToWechat:(NSString *)url thumbUrl:(NSString *)thumbUrl title:(NSString *)title desc:(NSString *)desc scene:(NSInteger)scene {
    NSURL *thumb = [NSURL URLWithString: thumbUrl];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:thumb]];
    [self shareToWechat:url thumb:image title:title desc:desc scene:scene];
}

- (void)shareToWechat:(NSString *)url thumb:(UIImage *)thumb title:(NSString *)title desc:(NSString *)desc scene:(NSInteger)scene {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = desc;
        [message setThumbImage:thumb];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (scene == 1) {
            req.scene = WXSceneSession;
        } else {
            req.scene = WXSceneTimeline;
        }
        
        [WXApi sendReq:req];
        
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"你的iPhone上还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

@end
