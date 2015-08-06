//
//  LeaderStatusViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LeaderStatusViewController.h"
#import "LeaderStatusModel.h"
#import "LeaderJoinedViewController.h"
#import "ApplyLeaderViewController.h"

@interface LeaderStatusViewController ()
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) ApplyLeaderViewController *applyLeaderVC;
@end

@implementation LeaderStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"成为领队";
    
    self.applyLeaderVC = [[ApplyLeaderViewController alloc]initWithParams:nil];
    [self addChildViewController:self.applyLeaderVC];
    
    [self.view addSubview:self.applyLeaderVC.view];
    [self.applyLeaderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    self.currentViewController = self.applyLeaderVC;
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    [self.view showLoadingBee];
    
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/leader/status")
                          parameters:nil cacheType:CacheTypeDisable JSONModelClass:[LeaderStatusModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self.view removeLoadingBee];
                                 
                                 LeaderStatusModel *result = (LeaderStatusModel *)responseObject;
                                 if ([result.data.status intValue] == 1) {
                                     //title
                                     self.navigationItem.title = @"活动列表";
                                     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"认领活动" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyLeaderClick)];
                                     
                                     LeaderJoinedViewController *leaderJoinedVC = [[LeaderJoinedViewController alloc]initWithParams:nil];
                                     leaderJoinedVC.model = result;
                                     [self addChildViewController:leaderJoinedVC];
                                     
                                     [self transitionFromViewController:self.currentViewController toViewController:leaderJoinedVC duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                     }  completion:^(BOOL finished) {
                                         if (finished) {
                                             [leaderJoinedVC didMoveToParentViewController:self];
                                             [self.currentViewController willMoveToParentViewController:nil];
                                             [self.currentViewController removeFromParentViewController];
                                             self.currentViewController = leaderJoinedVC;
                                             
                                         } else {
                                             self.currentViewController = self.currentViewController;
                                         }
                                     }];
                                     
                                 } else {
                                     self.applyLeaderVC.model = result;
                                 }
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self.view removeLoadingBee];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}

- (void)onApplyLeaderClick {
    [self openURL:@"duola://selectproduct"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
