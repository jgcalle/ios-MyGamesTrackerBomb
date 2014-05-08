//
//  NSString+Date.h
//  MyGamesTracker
//
//  Created by MIMO on 07/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (NSDate *)stringDateFromString:(NSString*)string;
+ (NSString *)stringDateFromDate:(NSDate*)date;
+ (NSString *)stringDateFromDatewithFormatUserLocate:(NSDate *)date;

@end
