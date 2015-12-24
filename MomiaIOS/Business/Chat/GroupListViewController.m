//
//  GroupListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/21.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "GroupListViewController.h"
#import "ChatListViewController.h"

@interface GroupListViewController ()

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"群组";
    
    ChatListViewController *chatListVC = [[ChatListViewController alloc]initWithParams:nil];
    [self addChildViewController:chatListVC];
    chatListVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
    [self.view addSubview:chatListVC.view];
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

@end
