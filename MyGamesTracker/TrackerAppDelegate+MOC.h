//
//  TrackerAppDelegate+MOC.h
//  MyGamesTracker
//
//  Created by MIMO on 04/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "TrackerAppDelegate.h"

@interface TrackerAppDelegate (MOC)

- (NSManagedObjectContext *)createMainQueueManagedObjectContext;

@end
