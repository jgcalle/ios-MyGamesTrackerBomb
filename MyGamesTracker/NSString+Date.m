//
//  NSString+Date.m
//  MyGamesTracker
//
//  Created by MIMO on 07/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSDateFormatter *)stringDateFormatter
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    return formatter;
}

+ (NSDateFormatter *)stringDateFormatterUserLocate
{
    static NSDateFormatter *formatterUser = nil;
    if (formatterUser == nil)
    {
        formatterUser = [[NSDateFormatter alloc] init];
        [formatterUser setDateStyle:NSDateFormatterMediumStyle];
    }
    return formatterUser;
}

+ (NSDate *)stringDateFromString:(NSString *)string
{
    NSDate *p = [[NSString stringDateFormatter] dateFromString:string];
    return p;
}


+ (NSString *)stringDateFromDate:(NSDate *)date
{
    return [[NSString stringDateFormatter] stringFromDate:date];
}

+ (NSString *)stringDateFromDatewithFormatUserLocate:(NSDate *)date
{
    return [[NSString stringDateFormatterUserLocate] stringFromDate:date];
}

@end
