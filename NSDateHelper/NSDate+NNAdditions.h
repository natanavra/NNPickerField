//
//  NSDate+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUTCTimeZone [NSTimeZone timeZoneWithName: @"UTC"]

extern NSString *const NSDatePOSIXFormat;

@interface NSDate (NNAdditions)


- (NSString *)POSIXFormatString;
- (BOOL)isDateInSameDay:(NSDate *)date;

/**
 *  Returns a string representation of the date with the given format.
 *  @param format Date format (RFC-something standard, Apple way...) must be valid <b><i>non-nil</b></i>
 */
- (NSString *)dateStringWithFormat:(NSString *)format;

/**
 *  @param date   A valid date object.
 *  @param format A valid string, date format (RFC standard)
 *  @return String representation of the date parameter in the given format with the device's default time zone.
 */
+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format;

/**
 *  @param date     A valid date object
 *  @param format   A valid string, date format (RFC standard)
 *  @param timeZone Optional timezone parameter. can be <i>nil</i>
 *  @return String representation of the given date in the given format with an optional offset according to the specified time zone.
 */
+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone;

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone;

+ (NSDate *)dateFromComponents:(NSDateComponents *)components;
+ (NSDateComponents *)dateComponents:(NSCalendarUnit)comps fromDate:(NSDate *)date;
- (NSDateComponents *)dateComponents:(NSCalendarUnit)comps;
- (NSDate *)dateFromSpecificComponents:(NSCalendarUnit)comps;

- (NSComparisonResult)timeCompare:(NSDate *)otherDate;

+ (NSArray *)monthSymbols;
+ (NSArray *)weekdaySymbols;
+ (NSString *)AMSymbol;
+ (NSString *)PMSymbol;

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date;
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month inYear:(NSInteger)year;
+ (NSInteger)numberOfDaysInYear:(NSInteger)year;
+ (NSInteger)numberOfDaysInYearWithDate:(NSDate *)date;
+ (NSInteger)daysInYear:(NSDate *)date;

@end
