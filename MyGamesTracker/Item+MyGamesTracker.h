//
//  Item+MyGamesTracker.h
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Item.h"

extern NSString *const kItemEntityName;
extern NSString *const kItemEntityGameAttributeName;
extern NSString *const kItemEntityTrackerAttributeName;

@interface Item (MyGamesTracker)

+ (Item *)itemWithInfo:(NSDictionary *)itemDictionary
      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Item *)createItemInTracker:(Tracker *)tracker withGame:(Game *) game inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)isGame:(Game *)game inTracker:(Tracker *)tracker inManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)deleteItemInTracker:(Tracker *)tracker withGame:(Game *) game inManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)deleteIteminManagedObjectContext:(NSManagedObjectContext *)context;



@end
