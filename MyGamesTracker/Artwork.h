//
//  Artwork.h
//  MyGamesTracker
//
//  Created by MIMO on 10/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Artwork : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) Game *game;

@end
