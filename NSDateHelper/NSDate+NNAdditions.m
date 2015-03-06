//
//  NSDate+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSDate+NNAdditions.h"
#import "NNLogger.h"

#define kUTCTimeZone [NSTimeZone timeZoneWithName: @"UTC"]

NSString *const NSDatePOSIXFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@implementation NSDate (NNAdditions)

#pragma mark - toString Transformers

- (NSString *)dateStringWithFormat:(NSString *)format {
    return [NSDate dateStringFromDate: self withFormat: format];
}

- (NSString *)POSIXFormatString {
    return [NSDate dateStringFromDate: self withFormat: NSDatePOSIXFormat];
}

- (BOOL)isDateInSameDay:(NSDate *)date {
    if(date) {
        //Possibly a an optimized solution would be to compare one day before and one day after the compared date.
        //(date + 60*60*24 > self && date - 60*60*24 < self) ---> Means same date.
        NSDateComponents *selfComps = [self dateComponents: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
        NSDateComponents *dateComps = [date dateComponents: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];

        //If the dates are in the same year, month and day... they're the same day.
        if(selfComps.year == dateComps.year && selfComps.month == dateComps.month && selfComps.day == dateComps.day) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [self dateStringFromDate: date withFormat: format withTimeZone: nil];
}

+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone {
    if(date) {
        NSDateFormatter *formatter = [self dateFormatter];
        formatter.timeZone = timeZone ? timeZone : [NSTimeZone defaultTimeZone];
        formatter.dateFormat = format;
        return [formatter stringFromDate: date];
    }
    return nil;
}

#pragma mark - Date Constructors

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format {
    return [self dateFromString: dateString withFormat: format withTimeZone: nil];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone {
    if(dateString) {
        NSDateFormatter *formatter = [self dateFormatter];
        formatter.dateFormat = format;
        formatter.timeZone = timeZone ? timeZone : [NSTimeZone defaultTimeZone];
        return [formatter dateFromString: dateString];
    }
    return nil;
}

+ (NSDateComponents *)dateComponents:(NSCalendarUnit)comps fromDate:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    return [calendar components: comps fromDate: date];
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    NSCalendar *calendar = [self calendar];
    return [calendar dateFromComponents: components];
}

- (NSDateComponents *)dateComponents:(NSCalendarUnit)comps {
    return [[self class] dateComponents: comps fromDate: self];
}

- (NSDate *)dateFromSpecificComponents:(NSCalendarUnit)comps {
    return [[self class] dateFromComponents: [self dateComponents: comps]];
}

#pragma mark - Comparator

- (NSComparisonResult)timeCompare:(NSDate *)otherDate {
    if(otherDate) {
        NSCalendarUnit flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDate *selfTime = [self dateFromSpecificComponents: flags];
        NSDate *otherTime = [otherDate dateFromSpecificComponents: flags];
        return [selfTime compare: otherTime];
        //For some reason modulo does not return the correct (something with timezones again) (Time interval returns seconds with timezone)
        /*NSInteger thisTime = (NSInteger)fabs([self timeIntervalSince1970]);
        NSInteger otherTime = (NSInteger)fabs([date timeIntervalSince1970]);
        NSInteger oneDay = 60*60*24;
        double thisDiff = thisTime % oneDay;
        double hours = floor(thisDiff / 60 / 60);
        double minutes = floor((thisDiff - (hours * 60 * 60)) / 60);
        double seconds = floor(thisDiff - (hours * 60 * 60) - (minutes * 60));
        double otherDiff = otherTime % oneDay;
        double timeDiff = thisDiff - otherDiff;
        if(timeDiff == 0) {
            return NSOrderedSame;
        } else if(timeDiff < 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }*/
    }
    return NSOrderedDescending;
}

#pragma mark - Calendar Methods

+ (NSArray *)monthSymbols {
    NSCalendar *calendar = [self calendar];
    return [calendar monthSymbols];
}

+ (NSArray *)weekdaySymbols {
    NSCalendar *calendar = [self calendar];
    return [calendar weekdaySymbols];
}

+ (NSString *)AMSymbol {
    NSCalendar *calendar = [self calendar];
    return [calendar AMSymbol];
}

+ (NSString *)PMSymbol {
    NSCalendar *calendar = [self calendar];
    return [calendar PMSymbol];
}

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date {
    NSRange range = [self rangeOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate: date];
    return (range.location != NSNotFound) ? range.length : 0;
}

+ (NSInteger)numberOfDaysInYearWithDate:(NSDate *)date {
    return [self numberOfDaysInYearWithComponents: [self dateComponents: NSCalendarUnitYear fromDate: date]];
}

+ (NSInteger)numberOfDaysInYear:(NSInteger)year {
    if(year == NSNotFound) {
        year = 1970;
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    return [self numberOfDaysInYearWithComponents: components];
}

+ (NSInteger)numberOfDaysInYearWithComponents:(NSDateComponents *)components {
    NSDate *yearDate = [self dateFromComponents: components];
    components.year += 1;
    NSDate *nextYear = [self dateFromComponents: components];
    NSTimeInterval secondsInYear = [nextYear timeIntervalSinceDate: yearDate];
    return secondsInYear / (60 * 60 * 24);
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month inYear:(NSInteger)year {
    if(year == NSNotFound) {
        year = 1970;
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.month = month;
    comps.year = year;
    NSDate *date = [self dateFromComponents: comps];
    NSRange range = [self rangeOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate: date];
    return (range.location != NSNotFound) ? range.length : 0;
}

+ (NSInteger)daysInYear:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    return [calendar ordinalityOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitYear forDate: date];
}

+ (NSRange)rangeOfUnit:(NSCalendarUnit)unit1 inUnit:(NSCalendarUnit)unit2 forDate:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    NSRange range = [calendar rangeOfUnit: unit1 inUnit: unit2 forDate: date];
    return range;
}

#pragma mark - Cached Instances

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    formatter.timeZone = [NSTimeZone defaultTimeZone];
    
    return formatter;
}

+ (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    return calendar;
}

@end
