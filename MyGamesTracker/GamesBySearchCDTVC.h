//
//  GamesBySearchCDTVC.h
//  MyGamesTracker
//
//  Created by MIMO on 13/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GamesCDTVC.h"

@interface GamesBySearchCDTVC : GamesCDTVC

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSDictionary *gameQuery;

@end
