//
//  PayResultViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PayResultViewController.h"
#import "PayCheckModel.h"

@interface PayResultViewController ()

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) PayCheckModel *payCheckResult;

@end

@implementation PayResultViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithNibName:@"PayResultViewController" bundle:nil]) {
        self.oid = [params objectForKey:@"oid"];
        self.pid = [params objectForKey:@"pid"];
        self.sid = [params objectForKey:@"sid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付结果";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"回到首页" style:UIBarButtonItemStyleDone target:self action:@selector(onBackToHome)];
    
    [self checkPayResult];
}

- (void)onBackToHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkPayResult {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"oid":self.oid, @"pid":self.pid, @"sid":self.sid};
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/payment/check")
                           parameters:params JSONModelClass:[PayCheckModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.payCheckResult = (PayCheckModel *)responseObject;
                                  
                                  if ([self.payCheckResult.data isEqualToString:@"OK"]) {
                                      self.titleLabel.text = @"您已购买成功";
                                      self.descLabel.text = @"活动前一天，或者活动发生变更，都会有短信通知您";
                                      
                                  } else {
                                      self.titleLabel.text = @"购买失败";
                                      self.descLabel.text = @"请重新确认订单，如有问题可拨打客服热线：021-62578700";
                                  }

                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
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
    if ([self.payCheckResult.data isEqualToString:@"OK"]) {
        
        
    } else {
        [self openURL:@"tel://02162578700"];
    }
}

- (IBAction)onRightButtonClicked:(id)sender {
    [self openURL:@"duola://orderlist"];
}
@end
