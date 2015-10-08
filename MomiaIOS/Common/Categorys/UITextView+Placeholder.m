//
//  UITextView+PlaceHolder.m
//  TextViewPlaceHolderDemo
//
//  Created by Brant on 14-8-8.
//  Copyright (c) 2014年 Brant. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

static const char *phTextView = "placeHolderTextView";
static const char *moTextView = "moTextView";


@implementation UITextView (PlaceHolder)

- (id<MOTextViewDelegate>) moDelegate {
    return objc_getAssociatedObject(self, moTextView);
}

- (void)setMoDelegate:(id<MOTextViewDelegate>)moDelegate{
    objc_setAssociatedObject(self, moTextView, moDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, phTextView);
}

- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)addPlaceHolder:(NSString *)placeHolder {
    if (![self placeHolderTextView]) {
        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        
        [self setPlaceHolderTextView:textView];
    }
    
}

# pragma mark -
# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderTextView.hidden = YES;
    if ([self.moDelegate respondsToSelector:@selector(moTextViewDidBeginEditing:)]) {
        [self.moDelegate moTextViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text && [textView.text isEqualToString:@""]) {
        self.placeHolderTextView.hidden = NO;
    }
    if ([self.moDelegate respondsToSelector:@selector(moTextViewDidEndEditing:)]) {
        [self.moDelegate moTextViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.moDelegate respondsToSelector:@selector(moTextView:shouldChangeTextInRange:replacementText:)]) {
        [self.moDelegate moTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    if (self.returnKeyType == UIReturnKeyDone && [text isEqualToString:@"\n"]){
        [textView resignFirstResponder];//关闭键盘
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.moDelegate respondsToSelector:@selector(moTextViewDidChange:)]) {
        [self.moDelegate moTextViewDidChange:textView];
    }
}

@end