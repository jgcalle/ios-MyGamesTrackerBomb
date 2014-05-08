//
//  Item+MyGamesTracker.m
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Item+MyGamesTracker.h"
#import "Game.h"
#import "Tracker.h"

NSString *const kItemEntityName                 = @"Item";
NSString *const kItemEntityGameAttributeName    = @"game";
NSString *const kItemEntityTrackerAttributeName = @"tracker";

@implementation Item (MyGamesTracker)

+ (BOOL) isGame:(Game *)game inTracker:(Tracker *)tracker inManagedObjectContext:(NSManagedObjectContext *)context;
{
    
    BOOL isIncluded = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kItemEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(game.title CONTAINS[cd] %@) AND (tracker.name CONTAINS[cd] %@)", game.title, tracker.name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        isIncluded = YES;
    }
    
    return isIncluded;
    
}

+ (Item *) createItemInTracker:(Tracker *)tracker withGame:(Game *) game inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kItemEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(game.title CONTAINS[cd] %@) AND (tracker.name CONTAINS[cd] %@)", game.title, tracker.name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        item = [matches firstObject];
        
    } else {
        
        item = [NSEntityDescription insertNewObjectForEntityForName:kItemEntityName inManagedObjectContext:context];
        
        // Tracker
        item.tracker = tracker;
        
        // Game
        item.game = game;
        
        [context save:NULL];
        
    }
    
    return item;
}


+ (Item *)itemWithInfo:(NSDictionary *)itemDictionary
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    
    Game *game = [itemDictionary valueForKeyPath:kItemEntityGameAttributeName];
    Tracker *tracker = [itemDictionary valueForKeyPath:kItemEntityTrackerAttributeName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kItemEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(%@ CONTAINS[cd] %@) AND (%@ CONTAINS[cd] %@)", @"game.title", game.title, @"tracker.name",tracker.name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        item = [matches firstObject];
        
    } else {
        
        item = [NSEntityDescription insertNewObjectForEntityForName:kItemEntityName inManagedObjectContext:context];
    
        // Tracker
        item.tracker = tracker;
        
        // Game
        item.game = game;
     
        [context save:NULL];
        
    }
    
    return item;
}


+ (BOOL) deleteItemInTracker:(Tracker *)tracker withGame:(Game *) game inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item  = nil;
    BOOL isOk   = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kItemEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(game.title CONTAINS[cd] %@) AND (tracker.name CONTAINS[cd] %@)", game.title, tracker.name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        item = [matches firstObject];
        [context deleteObject:item];

        // Save Context
        NSError *error = nil;
        [context save:&error];
        
        if (!error) {
            isOk = YES;
        }
        
    }
    return isOk;
}


- (BOOL) deleteIteminManagedObjectContext:(NSManagedObjectContext *)context
{
    BOOL isOk = NO;
    [context deleteObject:self];
    
    // Save Context
    NSError *error = nil;
    [context save:&error];
    if (!error) {
        isOk = YES;
    }
    
    return isOk;
}

@end
