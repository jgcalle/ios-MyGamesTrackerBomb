//
//  NSString+NSSet.h
//  MyGamesTracker
//
//  Created by MIMO on 27/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStringSeparatorOneLine;
extern NSString *const kStringSeparatorManyLines;

@interface NSString (NSSet)

+ (NSString *)stringListFromNSSet:(NSSet *)set ofItem:(NSString *)type withSeparator:(NSString *)separator;

@end


