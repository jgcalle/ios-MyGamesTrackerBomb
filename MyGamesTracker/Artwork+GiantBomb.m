//
//  Artwork+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 20/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Artwork+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kArtworkEntityName = @"Artwork";

@implementation Artwork (GiantBomb)

+ (Artwork *)artworkWithGiantBombInfo:(NSDictionary *)artworkDictionary
               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Artwork *artwork = nil;
    
    artwork = [NSEntityDescription insertNewObjectForEntityForName:kArtworkEntityName inManagedObjectContext:context];
    
    NSString *data = nil;
    
    // Tags
    data = [artworkDictionary valueForKeyPath:GIANTBOMB_ARTWORK_TAGS];
    if (![data isKindOfClass:[NSNull class]]) artwork.tags = data;
    
    // Image
    artwork.imageURL = [GiantBombFetcher URLforImage:artworkDictionary format:GiantBombImageFormatMedium];
    
    return artwork;
    
}

+ (NSSet *)loadArtworksFromGiantBombArray:(NSArray *)artworks   // of GiantBomb.com NSDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfArtwoks = [NSMutableSet set];
    for (NSDictionary *artwork in artworks) {
        [setOfArtwoks addObject:[self artworkWithGiantBombInfo:artwork inManagedObjectContext:context]];
    }
    return setOfArtwoks;
    
}

@end
