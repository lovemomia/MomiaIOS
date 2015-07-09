//
//  PaySuccessViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PayCheckModel.h"

@interface PaySuccessViewController ()

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *sid;

@end

@implementation PaySuccessViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
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
}

- (void)checkPayResult {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"oid":self.oid, @"pid":self.pid, @"sid":self.sid};
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/payment/check")
                           parameters:params JSONModelClass:[PayCheckModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  PayCheckModel *result = (PayCheckModel *)responseObject;
                                  if ([result.data isEqualToString:@"OK"]) {
                                      NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PaySuccessViewController" owner:self options:nil];
                                      self.view = [arr objectAtIndex:0];
                                  } else {
                                      NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PaySuccessViewController" owner:self options:nil];
                                      self.view = [arr objectAtIndex:1];
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

- (IBAction)onShareClick:(id)sender {
}

- (IBAction)onMyOrderClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"duola://orderlist"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
