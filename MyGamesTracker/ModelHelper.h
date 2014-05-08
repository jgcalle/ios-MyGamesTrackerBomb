//
//  ModelHelper.h
//  MyGamesTracker
//
//  Created by MIMO on 28/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NSGamesTrackerErrorDomain;

@interface ModelHelper : NSObject

// Errors management helper methods
+ (void)displayAlertError:(NSError *)anError;

@end
