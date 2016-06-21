//
//  MOWebViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/6.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface MOWebViewController : MOViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *navTitle;

@property (nonatomic, retain) UIWebView *webView;

@end
