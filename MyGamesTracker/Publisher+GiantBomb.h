//
//  Publisher+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Publisher.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchPublishersCompletionBlock)(NSArray *publishers, NSError *error);

extern NSString *const kPublisherEntityName;

@interface Publisher (GiantBomb)

+ (Publisher *)publisherWithGiantBombInfo:(NSDictionary *)publisherDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadPublishersFromGiantBombArray:(NSArray *)publishers   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end