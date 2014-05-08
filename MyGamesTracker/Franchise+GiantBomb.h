//
//  Franchise+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Franchise.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchFranchisesCompletionBlock)(NSArray *franchises, NSError *error);

extern NSString *const kFranchiseEntityName;

@interface Franchise (GiantBomb)

+ (Franchise *)franchiseWithGiantBombInfo:(NSDictionary *)franchiseDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadFranchisesFromGiantBombArray:(NSArray *)franchises   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context;


@end