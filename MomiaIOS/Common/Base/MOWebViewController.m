//
//  MOWebViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/6.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOWebViewController.h"

@interface MOWebViewController ()

@end

@implementation MOWebViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.url = [[params objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.navTitle = [params objectForKey:@"title"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:self.navTitle];
    if (self.webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.webView setDelegate:self];
        [self.webView setScalesPageToFit:YES];
        [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [self.view addSubview:self.webView];
    }
    
    [self loadUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.webView setFrame:self.view.bounds];
}

- (void)dealloc {
    if (self.webView != nil) {
        self.webView.delegate = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadUrl {
    if (self.webView != nil && self.url != nil) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

@end
