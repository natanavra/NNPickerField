//
//  NNDatePickerField.h
//  NNLibraries
//
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNPickerField.h"

@class NNDatePickerField;

@protocol NNDatePickerFieldDelegate <NNPickerFieldDelegate>
@optional
- (void)datePickerField:(NNDatePickerField *)datePickerField dateChangedToDate:(NSDate *)date;
- (BOOL)datePickerField:(NNDatePickerField *)datePickerField shouldChangeToDate:(NSDate *)date;
@end

@interface NNDatePickerField : NNPickerField
@property (nonatomic, weak) id<NNDatePickerFieldDelegate> pickerDelegate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

/** The format in which the selected date will be displayed. If not set, default to dd/MM/yyyy */
@property (nonatomic, strong) NSString *dateDisplayFormat;
/** Defaults to UIDatePickerModeTime */
@property (nonatomic) UIDatePickerMode datePickerMode;

- (NSString *)selectedDateStringWithFormat:(NSString *)format;

@end
