//
//  UITextView+PlaceHolder.h
//  TextViewPlaceHolderDemo
//
//  Created by Brant on 14-8-8.
//  Copyright (c) 2014年 Brant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@protocol MOTextViewDelegate <NSObject>

- (void)moTextViewDidBeginEditing:(UITextView *)textView;
- (void)moTextViewDidEndEditing:(UITextView *)textView;
- (void)moTextViewDidChange:(UITextView *)textView;
- (BOOL)moTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface UITextView (PlaceHolder) <UITextViewDelegate>

@property (nonatomic, strong) id<MOTextViewDelegate> moDelegate;
@property (nonatomic, strong) UITextView *placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
- (void)addPlaceHolder:(NSString *)placeHolder;

@end