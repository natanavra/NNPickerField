//
//  NNDatePickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/17/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNDatePickerField.h"
#import "NSDate+NNAdditions.h"

typedef NS_ENUM(NSInteger, toolbarItemIndex) {
    toolbarClearItemIndex = 0,
    toolbarTitleItemIndex = 2,
    toolbarCloseItemIndex = 4,
};

@interface NNDatePickerField ()
@property (nonatomic, weak) UIDatePicker *datePicker;
@end

@implementation NNDatePickerField
@synthesize pickerPlaceholder = _pickerPlaceholder;
@synthesize pickerDelegate = _pickerDelegate;

#pragma mark - Overrides

- (BOOL)resignFirstResponder {
    [_datePicker removeTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    return [super resignFirstResponder];
}

- (void)PROTECTED(clearField) {
    _selectedDate = nil;
    _datePicker.date = _datePicker.minimumDate ? _datePicker.minimumDate : [NSDate date];
    [super PROTECTED(clearField)];
}

#pragma mark - UIDatePicker Related

- (UIDatePicker *)classDatePicker {
    static UIDatePicker *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[UIDatePicker alloc] init];
    });
    return picker;
}

- (void)PROTECTED(setupPicker) {
    [super PROTECTED(setupPicker)];
    
    UIDatePicker *datePicker = [self classDatePicker];
    _datePicker = datePicker;
    [datePicker addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    datePicker.datePickerMode = _datePickerMode;
    datePicker.minimumDate = _minimumDate;
    datePicker.maximumDate = _maximumDate;
    [self setSelectedDate: _selectedDate ? _selectedDate : [NSDate date]];
    self.inputView = datePicker;
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    [self handleDateChangedWithDate: datePicker.date];
}

- (void)handleDateChangedWithDate:(NSDate *)date {
    if([self isValidDate: date]) {
        BOOL shouldChange = YES;
        
        //Ask delegate wether we can change the date.
        if([_pickerDelegate respondsToSelector: @selector(datePickerField:shouldChangeToDate:)]) {
            shouldChange = [_pickerDelegate datePickerField: self shouldChangeToDate: date];
        }
        
        if(shouldChange) {
            _selectedDate = date;
            self.text = [self dateStringFromDate: date];
            
            if([_pickerDelegate respondsToSelector: @selector(datePickerField:dateChangedToDate:)]) {
                [_pickerDelegate datePickerField: self dateChangedToDate: _selectedDate];
            }
        }
    }
    _datePicker.date = _selectedDate ? _selectedDate : [NSDate date];
}

- (void)setSelectedDate:(NSDate *)date {
    [self handleDateChangedWithDate: date];
    /*_selectedDate = date;
    _datePicker.date = date;
    self.text = [self dateStringFromDate: date];*/
}

- (void)setMinimumDate:(NSDate *)date {
    if(!_maximumDate) {
        _minimumDate = date;
    } else if([_maximumDate compare: date] != NSOrderedAscending) {
        _minimumDate = date;
    }
    
    //If current date is invalid - change it to the minimum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setSelectedDate: date];
    }
}

- (void)setMaximumDate:(NSDate *)date {
    if(!_minimumDate) {
        _maximumDate = date;
    } else if([_minimumDate compare: date] != NSOrderedDescending) {
        _maximumDate = date;
    }
    
    //If current selected date is invalid - change it to the maximum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setSelectedDate: date];
    }
}

- (NSString *)selectedDateStringWithFormat:(NSString *)format {
    NSString *previousFormat = _dateDisplayFormat;
    _dateDisplayFormat = format;
    NSString *dateString = [self dateStringFromDate: _selectedDate];
    _dateDisplayFormat = previousFormat;
    return dateString;
}

- (BOOL)isValidDate:(NSDate *)date {
    if(!date) {
        return NO;
    }
    
    BOOL validDate = YES;
    BOOL timePickerMode = [self timePickerMode];
    if(_minimumDate) {
        if(timePickerMode) {
            if([_minimumDate timeCompare: date] == NSOrderedDescending) {
                validDate = NO;
            }
        } else if([_minimumDate compare: date] == NSOrderedDescending) {
            validDate = NO;
        }
    }
    if(_maximumDate) {
        if(timePickerMode) {
            if([_maximumDate timeCompare: date] == NSOrderedDescending) {
                validDate = NO;
            }
        } else if([_maximumDate compare: date] == NSOrderedAscending) {
            validDate = NO;
        }
    }
    
    return validDate;
}

#pragma mark - Helpers

- (BOOL)timePickerMode {
    return (_datePickerMode == UIDatePickerModeTime) || (_datePickerMode == UIDatePickerModeCountDownTimer);
}

- (NSString *)dateStringFromDate:(NSDate *)date {
    NSString *retVal = nil;
    if(_dateDisplayFormat.length > 0) {
        static NSDateFormatter *formatter = nil;
        if(!formatter) {
            formatter = [[NSDateFormatter alloc] init];
        }
        formatter.timeZone = [NSTimeZone defaultTimeZone];
    
        [formatter setDateFormat: _dateDisplayFormat];
        retVal = [formatter stringFromDate: date];
    } else {
        NSDateFormatterStyle dateStyle = NSDateFormatterShortStyle;
        NSDateFormatterStyle timeStyle = NSDateFormatterShortStyle;
        if(_datePickerMode == UIDatePickerModeTime || _datePickerMode == UIDatePickerModeCountDownTimer) {
            dateStyle = NSDateFormatterNoStyle;
        } else if(_datePickerMode == UIDatePickerModeDate) {
            timeStyle = NSDateFormatterNoStyle;
        }
        retVal = [NSDateFormatter localizedStringFromDate: date dateStyle: dateStyle timeStyle: timeStyle];
    }
    return retVal;
}

@end
