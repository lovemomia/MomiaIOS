//
//  WendaHomeViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/13.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaHomeViewController.h"

@interface WendaHomeViewController ()

@end

@implementation WendaHomeViewController

- (BOOL)isNavDarkStyle {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"松果课堂";
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
