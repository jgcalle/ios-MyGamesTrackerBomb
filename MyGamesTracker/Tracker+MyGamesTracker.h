//
//  Tracker+MyGamesTracker.h
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Tracker.h"

extern NSString *const kTrackerEntityName;
extern NSString *const kTrackerEntityNameAttributeName;

@interface Tracker (MyGamesTracker)

+ (Tracker *)trackerWithInfo:(NSDictionary *)trackerDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Tracker *)getMyTrackerLibraryinManagedObjectContext:(NSManagedObjectContext *)context;

+ (Tracker *)getMyTrackerMustHavesinManagedObjectContext:(NSManagedObjectContext *)context;

@end
