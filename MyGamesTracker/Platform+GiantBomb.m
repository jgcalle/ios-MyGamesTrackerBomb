//
//  Platform+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Platform+GiantBomb.h"
#import "GiantBombFetcher.h"
#import "NSString+Date.h"
#import "NetworkAPIEngine.h"

NSString *const kPlatformEntityName = @"Platform";

@implementation Platform (GiantBomb)

+ (void)fetchAllPlatformsIntoManagedObjectContext:(NSManagedObjectContext *) context
                                          onCompletion:(FetchPlatformsCompletionBlock)completionBlock
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kPlatformEntityName];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    NSError *error = nil;
    NSArray *platforms = [context executeFetchRequest:request error:&error];
    
    if (error == nil) {
        if ([platforms count] == 0) {
                [[NetworkAPIEngine sharedInstance] fetchPlatformsIntoManagedObjectContext:context
                                                                                   offSet:0
                                                     onCompletion:^(NSArray *platforms, NSError *error) {
                                                         if (!error) {
                                                             [self fetchAllPlatformsIntoManagedObjectContext:context onCompletion:^(NSArray *platforms, NSError *error) {
                                                                 if (!error) {
                                                                    if (completionBlock) completionBlock(platforms, nil);
                                                                 } else {
                                                                    if (completionBlock) completionBlock(nil, error);
                                                                 }
                                                             }];
                                                             
                                                         } else {
                                                             if (completionBlock) completionBlock(nil, error);
                                                         }
                                                        }];
        } else {
            if (completionBlock) completionBlock(platforms, nil);
        }
    }
    else {
        if (completionBlock) completionBlock(nil, error);
    }
    
}



+ (Platform *)platformWithGiantBombInfo:(NSDictionary *)platformDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    Platform *platform = nil;
    
    NSString *id = [platformDictionary valueForKeyPath:GIANTBOMB_PLATFORM_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kPlatformEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
    
        platform = [matches firstObject];
    
    } else {
        
        platform = [NSEntityDescription insertNewObjectForEntityForName:kPlatformEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        platform.id = @([id intValue]);
        
        // IdAPI
        platform.idAPI = [platformDictionary valueForKeyPath:GIANTBOMB_PLATFORM_ID_API];
        
        // Name
        data = [platformDictionary valueForKeyPath:GIANTBOMB_PLATFORM_NAME];
        if (![data isKindOfClass:[NSNull class]]) platform.name = data;

        // Abbreviation
        data = [platformDictionary valueForKeyPath:GIANTBOMB_PLATFORM_ABBREVIATION];
        if (![data isKindOfClass:[NSNull class]]) platform.abbreviation = data;
        
        // Site Details URL
        data = [platformDictionary valueForKeyPath:GIANTBOMB_PLATFORM_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) platform.siteDetailsURL = data;
        
        
    }
    
    return platform;
    
}


+ (NSSet *)loadPlatformsFromGiantBombArray:(NSArray *)platforms   // of GiantBomb.com NSDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableSet* setOfPlatforms = [NSMutableSet set];
    for (NSDictionary *platform in platforms) {
        [setOfPlatforms addObject:[self platformWithGiantBombInfo:platform inManagedObjectContext:context]];
    }
    return setOfPlatforms;
}
@end
