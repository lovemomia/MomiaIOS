//
//  UITextView+PlaceHolder.h
//  TextViewPlaceHolderDemo
//
//  Created by Brant on 14-8-8.
//  Copyright (c) 2014年 Brant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITextView (PlaceHolder) <UITextViewDelegate>

@property (nonatomic, strong) UITextView *placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
- (void)addPlaceHolder:(NSString *)placeHolder;

@end