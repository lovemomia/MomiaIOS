//
//  DatePickerSheet.m
//  DatePickerSheetTest
//
//  Created by dujinfeng481 on 14-9-2.
//  Copyright (c) 2014年 djf. All rights reserved.
//

#import "DatePickerSheet.h"

#define parserLuaScriptParam(title, ...) [NSString stringWithFormat: title, ##__VA_ARGS__]

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

@interface DatePickerSheet() <UIActionSheetDelegate>

@property (nonatomic, strong) UIDatePicker      *curDatePicker;
@property (nonatomic, strong) UIActionSheet     *curActionSheet;
#ifdef __IPHONE_8_0
@property (nonatomic, strong) UIAlertController *curAlertController;
#endif
@property (nonatomic, assign) id <DatePickerSheetDelegate> curDelegate;

@end

@implementation DatePickerSheet

+ (DatePickerSheet*) getInstance
{
    static DatePickerSheet *instance = nil;
    @synchronized(self){
        if (instance == nil) {
            instance = [[DatePickerSheet alloc] init];
        }
        
        return instance;
    }
}

- (void) initializationWithMaxDate:(NSDate*)maxDate
                     withMinDate:(NSDate*)minDate
              withDatePickerMode:(UIDatePickerMode)mode
                    withDelegate:(id <DatePickerSheetDelegate>)delegate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = mode;
    datePicker.maximumDate = maxDate;
    datePicker.minimumDate = minDate;
    [self initializationWithDatePicker:datePicker withDelegate:delegate];
}

- (void) initializationWithDatePicker:(UIDatePicker*)datePicker
                       withDelegate:(id <DatePickerSheetDelegate>)delegate
{
    self.curDatePicker = datePicker;
    self.curDelegate = delegate;
    
#ifdef __IPHONE_8_0
    if ([self systemVersionLowerThan:@"8.0"])
    {
#endif
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        self.curActionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"OK", @"确定"), nil];
        [self.curActionSheet addSubview:self.curDatePicker];
#ifdef __IPHONE_8_0
    }else {
        NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n";
        self.curAlertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self.curAlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self clickedOkActionButton];
        }]];
        
        [self.curAlertController.view addSubview:self.curDatePicker];
    }
#endif
}

- (void) showDatePickerSheet
{
#ifdef __IPHONE_8_0
    if ([self systemVersionLowerThan:@"8.0"]) {
#endif
        [self.curActionSheet showInView:[[UIApplication sharedApplication].delegate window]];
#ifdef __IPHONE_8_0
    }else {
        if (self.curDelegate) {
            if ([self.curDelegate isKindOfClass:[UIViewController class]]) {
                UIViewController *parentVC = (UIViewController*)self.curDelegate;
                [parentVC presentViewController:self.curAlertController
                                       animated:YES
                                     completion:^{
                                     }];
            }
        }
    }
#endif
}


#pragma mark - private method
- (BOOL)systemVersionLowerThan:(NSString*)version
{
    if (version == nil || version.length == 0) {
        NSLog(@"### Error Version");
        return NO;
    }
    
    if ([[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) clickedOkActionButton
{
    if (self.curDelegate && [self.curDelegate respondsToSelector:@selector(datePickerSheet:chosenDate:)]) {
        [self.curDelegate datePickerSheet:self chosenDate:self.curDatePicker.date];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clickedOkActionButton];
}

@end
