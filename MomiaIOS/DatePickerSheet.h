//
//  DatePickerSheet.h
//  DatePickerSheetTest
//
//  Created by dujinfeng481 on 14-9-2.
//  Copyright (c) 2014年 djf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>

@protocol DatePickerSheetDelegate;

@interface DatePickerSheet : NSObject

+ (DatePickerSheet*) getInstance;

- (void) initializationWithMaxDate:(NSDate*)maxDate
                     withMinDate:(NSDate*)minDate
              withDatePickerMode:(UIDatePickerMode)mode
                    withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) initializationWithDatePicker:(UIDatePicker*)datePicker
                       withDelegate:(id <DatePickerSheetDelegate>)delegate;

- (void) showDatePickerSheet;

@end


@protocol DatePickerSheetDelegate <NSObject>

-(void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date;

@end
