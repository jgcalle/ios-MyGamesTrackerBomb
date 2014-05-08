//
//  Artwork+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 20/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Artwork.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchArtworksCompletionBlock)(NSArray *artworks, NSError *error);

extern NSString *const kArtworkEntityName;

@interface Artwork (GiantBomb)

+ (Artwork *)artworkWithGiantBombInfo:(NSDictionary *)artworkDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadArtworksFromGiantBombArray:(NSArray *)artworks   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context;

@end