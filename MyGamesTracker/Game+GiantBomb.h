//
//  Game+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Game.h"

typedef enum {
	createGame    = 1,          // to create a new game
	updateGame    = 2,          // to update game with plus info
    updateAllGame = 3           // to update all game info
} OperationOnGame;

extern NSString *const kGameEntityName;
extern NSString *const kGameEntityTitleAttributeName;

@interface Game (GiantBomb)

+ (Game *)gameWithGiantBombInfo:(NSDictionary *)gameDictionary
                         action:(int)operation
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadGamesFromGiantBombArray:(NSArray *)games   // of GiantBomb.com NSDictionary
              inManagedObjectContext:(NSManagedObjectContext *)context;

@end
