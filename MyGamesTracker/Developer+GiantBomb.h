//
//  Developer+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Developer.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchDevelopersCompletionBlock)(NSArray *developers, NSError *error);

extern NSString *const kDeveloperEntityName;

@interface Developer (GiantBomb)

+ (Developer *)developerWithGiantBombInfo:(NSDictionary *)developerDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadDevelopersFromGiantBombArray:(NSArray *)developers   // of GiantBomb.com NSDictionary
                    inManagedObjectContext:(NSManagedObjectContext *)context;


@end