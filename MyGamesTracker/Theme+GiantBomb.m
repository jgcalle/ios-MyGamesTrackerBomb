//
//  Theme+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Theme+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kThemeEntityName = @"Theme";

@implementation Theme (GiantBomb)

+ (Theme *)themeWithGiantBombInfo:(NSDictionary *)themeDictionary
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    Theme *theme = nil;
    
    NSString *id = [themeDictionary valueForKeyPath:GIANTBOMB_THEME_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kThemeEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        theme = [matches firstObject];
    
    } else {
        
        theme = [NSEntityDescription insertNewObjectForEntityForName:kThemeEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        theme.id = @([id intValue]);
        
        // Name
        data = [themeDictionary valueForKeyPath:GIANTBOMB_THEME_NAME];
        if (![data isKindOfClass:[NSNull class]]) theme.name = data;
        
        // Site Details URL
        data = [themeDictionary valueForKeyPath:GIANTBOMB_THEME_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) theme.siteDetailsURL = data;
        
    }
    
    return theme;
    
}

+ (NSSet *)loadThemesFromGiantBombArray:(NSArray *)themes   // of GiantBomb.com NSDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfThemes = [NSMutableSet set];
    for (NSDictionary *theme in themes) {
        [setOfThemes addObject:[self themeWithGiantBombInfo:theme inManagedObjectContext:context]];
    }
    return setOfThemes;
    
}

@end
