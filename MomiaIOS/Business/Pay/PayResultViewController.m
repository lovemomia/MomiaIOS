//
//  PayResultViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PayResultViewController.h"
#import "PayCheckModel.h"
#import "ThirdShareHelper.h"
#import "SGActionView.h"

@interface PayResultViewController ()

@property (nonatomic, strong) NSString *oid;

@property (nonatomic, assign) BOOL free;
@property (nonatomic, strong) NSString *coupon;

@property (nonatomic, strong) PayCheckModel *payCheckResult;

@end

@implementation PayResultViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:@"PayResultViewController" bundle:nil]) {
        self.oid = [params objectForKey:@"oid"];
        self.free = [[params objectForKey:@"free"] boolValue];
        self.coupon = [params objectForKey:@"coupon"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付结果";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleBack"] style:UIBarButtonItemStyleDone target:self action:@selector(onBackToHome)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onBackToHome)];
    
    if (self.free) {
        [self freePay];
    } else {
        [self checkPayResult];
    }
}

- (void)onBackToHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkPayResult {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"oid":self.oid};
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/payment/check")
                           parameters:params JSONModelClass:[PayCheckModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.payCheckResult = (PayCheckModel *)responseObject;
                                  
                                  if (self.payCheckResult.data.payed) {
                                      self.titleLabel.text = @"您已购买成功";
                                      self.descLabel.text = @"活动前一天，或者活动发生变更，都会有短信通知您";
                                  } else {
                                      self.titleLabel.text = @"购买失败";
//                                      self.leftButton.titleLabel.text = @"客服热线";
                                      self.descLabel.text = @"请重新确认订单，如有问题可联系客服微信：dorakids01";
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.titleLabel.text = @"购买失败";
//                                  self.leftButton.titleLabel.text = @"客服热线";
                                  self.descLabel.text = @"请重新确认订单，如有问题可联系客服微信：dorakids01";
                              }];
}

- (void)freePay {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"oid":self.oid, @"coupon":self.coupon};
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/payment/prepay/free")
                           parameters:params JSONModelClass:[PayCheckModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.payCheckResult = (PayCheckModel *)responseObject;
                                  
                                  if (self.payCheckResult.data.payed) {
                                      self.titleLabel.text = @"您已购买成功";
                                      self.descLabel.text = @"活动前一天，或者活动发生变更，都会有短信通知您";
                                  } else {
                                      self.titleLabel.text = @"购买失败";
//                                      self.leftButton.titleLabel.text = @"客服热线";
                                      self.descLabel.text = @"请重新确认订单，如有问题可联系客服微信：dorakids01";
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.titleLabel.text = @"购买失败";
//                                  self.leftButton.titleLabel.text = @"客服热线";
                                  self.descLabel.text = @"请重新确认订单，如有问题可联系客服微信：dorakids01";
                              }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLeftButtonClicked:(id)sender {
    if (self.payCheckResult.data.payed) {
        ThirdShareHelper *helper = [ThirdShareHelper new];
        [SGActionView showGridMenuWithTitle:@"约伴"
                                 itemTitles:@[ @"微信好友", @"微信朋友圈"]
                                     images:@[ [UIImage imageNamed:@"IconShareWechat"],
                                               [UIImage imageNamed:@"IconShareWechatTimeline"]]
                             selectedHandle:^(NSInteger index) {
                                 if (index == 1) {
                                     [helper shareToWechat:self.payCheckResult.data.url thumbUrl:self.payCheckResult.data.thumb title:self.payCheckResult.data.title desc:self.payCheckResult.data.abstracts scene:1];
                                 } else if (index == 2) {
                                     [helper shareToWechat:self.payCheckResult.data.url thumbUrl:self.payCheckResult.data.thumb title:self.payCheckResult.data.title desc:self.payCheckResult.data.abstracts scene:2];
                                 }
                             }];
        
    } else {
//        [self openURL:@"tel://02162578700"];
    }
}

- (IBAction)onRightButtonClicked:(id)sender {
    [self openURL:@"duola://myorderlist?status=3"];
}
@end
