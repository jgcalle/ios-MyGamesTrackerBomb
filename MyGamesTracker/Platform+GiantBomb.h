//
//  Platform+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Platform.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchPlatformsCompletionBlock)(NSArray *platforms, NSError *error);

extern NSString *const kPlatformEntityName;

@interface Platform (GiantBomb)

+ (Platform *)platformWithGiantBombInfo:(NSDictionary *)platformDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadPlatformsFromGiantBombArray:(NSArray *)platforms   // of GiantBomb.com NSDictionary
             inManagedObjectContext:(NSManagedObjectContext *)context;


+ (void)fetchAllPlatformsIntoManagedObjectContext:(NSManagedObjectContext *) context
                                  onCompletion:(FetchPlatformsCompletionBlock)completionBlock;

@end
