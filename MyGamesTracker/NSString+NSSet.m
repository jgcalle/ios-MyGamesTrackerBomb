//
//  NSString+NSSet.m
//  MyGamesTracker
//
//  Created by MIMO on 27/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "NSString+NSSet.h"

NSString *const kStringSeparatorOneLine = @", ";
NSString *const kStringSeparatorManyLines = @"\n";

@implementation NSString (NSSet)

+ (NSString *)stringListFromNSSet:(NSSet *)set ofItem:(NSString *)type withSeparator:(NSString *)separator
{
    NSString *shortedList = @"";
    if ([set count] > 0) {

        // Get list of NSString items and add Separator
        NSMutableString *list = [[NSMutableString alloc] init];
        for (id item in set) {
            [list appendString:[NSString stringWithFormat:@"%@%@",[item valueForKey:type],separator]];
        }
        
        // Remove last Separator
        NSRange r;
        r.location = 0;
        r.length = [list length] - [separator length];
        shortedList = [list substringWithRange:r];

    }
    
    return shortedList;
}

@end
