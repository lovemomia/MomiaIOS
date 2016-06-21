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
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"提问" forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 200, SCREEN_WIDTH, 48);
    button1.backgroundColor = [UIColor greenColor];
    [button1 addTarget:self action:@selector(toAskQuestionViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}


-(void)toAskQuestionViewController{
    
    
    [self openURL:@"askquestion"];
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
