//
//  ShareViewCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/18.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ShareViewCell.h"
#import "CouponShareModel.h"
#import "ThirdShareHelper.h"
#import "SGActionView.h"

@interface ShareViewCell()
@property (nonatomic, strong) CouponShareData *model;
@end

@implementation ShareViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CouponShareData *)data {
    self.model = data;
    [self.photoIv sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"BgCouponShare"]];

    self.discLabel.text = data.desc;
}

- (IBAction)onShareClicked:(id)sender {
    if (self.model) {
        ThirdShareHelper *helper = [ThirdShareHelper new];
        [SGActionView showGridMenuWithTitle:@"邀请好友"
                                 itemTitles:@[ @"微信好友", @"微信朋友圈"]
                                     images:@[ [UIImage imageNamed:@"IconShareWechat"],
                                               [UIImage imageNamed:@"IconShareWechatTimeline"]]
                             selectedHandle:^(NSInteger index) {
                                 NSString *url = self.model.url;
                                 
                                 [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
                                 
                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                     NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.model.cover]];
                                     UIImage *image = [[UIImage alloc]initWithData:data];
                                     if (data != nil) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             //在这里做UI操作(UI操作都要放在主线程中执行)
                                             [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                                             NSString *title = self.model.title;
                                             NSString *desc = self.model.abstracts;
                                             if (index == 1) {
                                                 [helper shareToWechat:url thumb:image title:title desc:desc scene:1];
                                             } else if (index == 2) {
                                                 [helper shareToWechat:url thumb:image title:title desc:desc scene:2];
                                             }
                                         }); 
                                     } 
                                 });
                             }];
    }
}


@end
