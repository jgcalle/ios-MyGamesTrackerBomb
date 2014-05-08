//
//  Item.h
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Tracker;

@interface Item : NSManagedObject

@property (nonatomic, retain) Tracker *tracker;
@property (nonatomic, retain) Game *game;

@end
