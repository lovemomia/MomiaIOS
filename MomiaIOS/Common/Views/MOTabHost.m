//
//  MOTabHost.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTabHost.h"

@interface MOTabHost()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIView *shadow;
@end

@implementation MOTabHost

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]) {
        self.items = items;
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < items.count; i ++) {
            [self addItem:[items objectAtIndex:i] index:i];
        }
    }
    return self;
}

- (UIView *)addItem:(NSString *)title index:(NSInteger)index {
    UIView *view = [[UIView alloc]init];
    view.height = self.height;
    CGFloat width = self.width / self.items.count;
    view.width = width;
    view.left = width * index;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, self.height)];
    titleLabel.text = title;
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    [self addSubview:view];
    
    UIView *bottomSep = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 0.5)];
    bottomSep.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:bottomSep];
    
    view.tag = index;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTabClick:)];
    [view addGestureRecognizer:singleTap];
    
    return view;
}

-(void)onTabClick:(UITapGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    [self setItemSelect:index];
    if (self.onItemClickedListener) {
        self.onItemClickedListener(index);
    }
}

- (void)setItemSelect:(NSInteger)index {
    CGFloat width = self.width / self.items.count;
    if (self.shadow == nil) {
        self.shadow = [[UIView alloc]init];
        self.shadow.width = width;
        self.shadow.height = 2;
        self.shadow.backgroundColor = MO_APP_ThemeColor;
        self.shadow.top = self.height - 2;
        self.shadow.left = width * index;
        [self addSubview:self.shadow];
        
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.shadow cache:YES];
//        [UIView setAnimationDuration:1];
        
        CGRect frame= self.shadow.frame;
        frame.origin.x = width * index;
        self.shadow.frame = frame;

        [UIView commitAnimations];
    }
}

@end
