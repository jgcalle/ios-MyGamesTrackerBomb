//
//  Genre+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Genre.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchGenresCompletionBlock)(NSArray *genres, NSError *error);

extern NSString *const kGenreEntityName;

@interface Genre (GiantBomb)

+ (Genre *)genreWithGiantBombInfo:(NSDictionary *)genreDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadGenresFromGiantBombArray:(NSArray *)genres   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
