//
//  Genre+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Genre+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kGenreEntityName = @"Genre";

@implementation Genre (GiantBomb)

+ (Genre *)genreWithGiantBombInfo:(NSDictionary *)genreDictionary
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    Genre *genre = nil;
    
    NSString *id = [genreDictionary valueForKeyPath:GIANTBOMB_GENRE_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGenreEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        genre = [matches firstObject];
    
    } else {
        
        genre = [NSEntityDescription insertNewObjectForEntityForName:kGenreEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        genre.id = @([id intValue]);
        
        // Name
        data = [genreDictionary valueForKeyPath:GIANTBOMB_FRANCHISE_NAME];
        if (![data isKindOfClass:[NSNull class]]) genre.name = data;
        
    }
    
    return genre;
    
}

+ (NSSet *)loadGenresFromGiantBombArray:(NSArray *)genres   // of GiantBomb.com NSDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfGenres = [NSMutableSet set];
    for (NSDictionary *genre in genres) {
        [setOfGenres addObject:[self genreWithGiantBombInfo:genre inManagedObjectContext:context]];
    }
    return setOfGenres;
    
}

@end
