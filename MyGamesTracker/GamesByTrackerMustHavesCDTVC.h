//
//  GamesByTrackerMustHavesCDTVC.h
//  MyGamesTracker
//
//  Created by MIMO on 12/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GamesCDTVC.h"

@interface GamesByTrackerMustHavesCDTVC : GamesCDTVC

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
