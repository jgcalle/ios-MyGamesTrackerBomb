//
//  Game+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Game+GiantBomb.h"
#import "Platform+GiantBomb.h"
#import "GiantBombFetcher.h"
#import "Developer+GiantBomb.h"
#import "Publisher+GiantBomb.h"
#import "Franchise+GiantBomb.h"
#import "Genre+GiantBomb.h"
#import "Theme+GiantBomb.h"
#import "Artwork+GiantBomb.h"
#import "NSString+Date.h"

NSString *const kGameEntityName               = @"Game";
NSString *const kGameEntityTitleAttributeName = @"title";

@implementation Game (GiantBomb)

+ (Game *)gameWithGiantBombInfo:(NSDictionary *)gameDictionary
                         action:(int)operation
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Game *game = nil;
    
    NSString *id = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGameEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        game = [matches firstObject];
        
        // Update Game (with plus data)
        if (operation == updateGame) {
            
            NSArray *array = nil;

            // Date Last Updated
            game.dateLastUpdated = [NSDate date];
            
            // Set of Developers
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_DEVELOPERS];
            if (![array isKindOfClass:[NSNull class]]) [game addDevelopers:[Developer loadDevelopersFromGiantBombArray:array inManagedObjectContext:context]];
            
            // Set of Publishers
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_PUBLISHERS];
            if (![array isKindOfClass:[NSNull class]]) [game addPublishers:[Publisher loadPublishersFromGiantBombArray:array inManagedObjectContext:context]];
            
            // Set of Franchises
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_FRANCHISES];
            if (![array isKindOfClass:[NSNull class]]) [game addFranchises:[Franchise loadFranchisesFromGiantBombArray:array inManagedObjectContext:context]];
            
            // Set of Genres
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_GENRES];
            if (![array isKindOfClass:[NSNull class]]) [game addGenres:[Genre loadGenresFromGiantBombArray:array inManagedObjectContext:context]];
            
            // Set of Themes
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_THEMES];
            if (![array isKindOfClass:[NSNull class]]) [game addThemes:[Theme loadThemesFromGiantBombArray:array inManagedObjectContext:context]];
            
            // Set of Images
            array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_ARTWORK];
            if (![array isKindOfClass:[NSNull class]]) {
                
                // Delete all images of the games
                [game removeImages:game.images];
                
                // Add all images of the games
                [game addImages:[Artwork loadArtworksFromGiantBombArray:array inManagedObjectContext:context]];
                
            }
        }
        
    } else {
        // Create Game
        game = [NSEntityDescription insertNewObjectForEntityForName:kGameEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        NSDictionary *dictionary = nil;
        NSArray *array = nil;
        
        // Id
        game.id = @([id intValue]);
        
        // Date Added
        game.dateAdded = [NSDate date];
        
        // IdAPI
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_ID_API];
        if (![data isKindOfClass:[NSNull class]]) game.idAPI = [data lastPathComponent];
        
        // Title
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_TITLE];
        if (![data isKindOfClass:[NSNull class]]) game.title = data;
        
        // Release Date
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_RELEASE_DATE];
        if (![data isKindOfClass:[NSNull class]]) game.releaseDate = [NSString stringDateFromString:data];
        
        // Image Screen
        dictionary = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_IMAGE];
        if (![dictionary isKindOfClass:[NSNull class]]) game.imageURL = [GiantBombFetcher URLforImage:dictionary format:GiantBombImageFormatScreen];
        
        // Image Thumbnail
        dictionary = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_IMAGE];
        if (![dictionary isKindOfClass:[NSNull class]]) game.imageThumbURL = [GiantBombFetcher URLforImage:dictionary format:GiantBombImageFormatThumb];
        
        // Image Super
        dictionary = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_IMAGE];
        if (![dictionary isKindOfClass:[NSNull class]]) game.imageSuperURL = [GiantBombFetcher URLforImage:dictionary format:GiantBombImageFormatSuper];
        
        // Info
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_INFO];
        if (![data isKindOfClass:[NSNull class]]) game.info = data;
        
        // Summary
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_SUMMARY];
        if (![data isKindOfClass:[NSNull class]]) game.summary = data;
        
        // Site Details URL
        data = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) game.siteDetailsURL = data;
        
        // Set of Platforms
        array = [gameDictionary valueForKeyPath:GIANTBOMB_GAMES_PLATFORMS];
        if (![array isKindOfClass:[NSNull class]]) [game addPlatforms:[Platform loadPlatformsFromGiantBombArray:array inManagedObjectContext:context]];

    }
    
    return game;
}


+ (NSSet *)loadGamesFromGiantBombArray:(NSArray *)games   // of GiantBomb.com NSDictionary
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableSet* setOfGames = [NSMutableSet set];
    for (NSDictionary *game in games) {
        [setOfGames addObject:[self gameWithGiantBombInfo:game action:createGame inManagedObjectContext:context]];
    }
    
    return setOfGames;
}

@end
