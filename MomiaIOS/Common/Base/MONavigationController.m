//
//  MONavigationController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MONavigationController.h"

@implementation MONavigationController
@synthesize alphaView;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    viewController.navigationItem.backBarButtonItem = item;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        alphaView.backgroundColor = [UIColor blueColor];
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setAlph {
    if (_changing == NO) {
        _changing = YES;
        if (alphaView.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
                alphaView.alpha = 1.0;
            } completion:^(BOOL finished) {
                _changing = NO;
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                alphaView.alpha = 0.0;
            } completion:^(BOOL finished) {
                _changing = NO;
                
            }];
        }
    }
}

@end
