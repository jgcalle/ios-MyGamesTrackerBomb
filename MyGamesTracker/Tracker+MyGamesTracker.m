//
//  Tracker+MyGamesTracker.m
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Tracker+MyGamesTracker.h"

NSString *const kTrackerEntityName              = @"Tracker";
NSString *const kTrackerEntityNameAttributeName = @"name";
NSString *const kTrackerLibraryName             = @"TrackerLibrary";
NSString *const kTrackerMustHavesName           = @"TrackerMustHaves";

@implementation Tracker (MyGamesTracker)

+ (Tracker *)getMyTrackerLibraryinManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *trackerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: kTrackerLibraryName, kTrackerEntityNameAttributeName, nil];
    
    return [Tracker trackerWithInfo:trackerDictionary inManagedObjectContext:context];
    
}

+ (Tracker *)getMyTrackerMustHavesinManagedObjectContext:(NSManagedObjectContext *)context
{
    NSDictionary *trackerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: kTrackerMustHavesName, kTrackerEntityNameAttributeName, nil];
    
    return [Tracker trackerWithInfo:trackerDictionary inManagedObjectContext:context];}


+ (Tracker *)trackerWithInfo:(NSDictionary *)trackerDictionary
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tracker *tracker = nil;
    
    NSString *name = [trackerDictionary valueForKeyPath:kTrackerEntityNameAttributeName];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kTrackerEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@" name == %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        tracker = [matches firstObject];
        
    } else {
        
        tracker = [NSEntityDescription insertNewObjectForEntityForName:kTrackerEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Name
        data = [trackerDictionary valueForKeyPath:kTrackerEntityNameAttributeName];
        if (![data isKindOfClass:[NSNull class]]) tracker.name = data;
        
        [context save:NULL];
        
    }
    
    return tracker;
}

@end
