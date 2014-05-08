//
//  Developer+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Developer+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kDeveloperEntityName = @"Developer";

@implementation Developer (GiantBomb)

+ (Developer *)developerWithGiantBombInfo:(NSDictionary *)developerDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Developer *developer = nil;
    
    NSString *id = [developerDictionary valueForKeyPath:GIANTBOMB_DEVELOPER_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDeveloperEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        developer = [matches firstObject];
    
    } else {
        
        developer = [NSEntityDescription insertNewObjectForEntityForName:kDeveloperEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        developer.id = @([id intValue]);
        
        // Name
        data = [developerDictionary valueForKeyPath:GIANTBOMB_DEVELOPER_NAME];
        if (![data isKindOfClass:[NSNull class]]) developer.name = data;
        
        
        // Site Details URL
        data = [developerDictionary valueForKeyPath:GIANTBOMB_DEVELOPER_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) developer.siteDetailsURL = data;
        
    }
    
    return developer;

}

+ (NSSet *)loadDevelopersFromGiantBombArray:(NSArray *)developers   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfDevelopers = [NSMutableSet set];
    for (NSDictionary *developer in developers) {
        [setOfDevelopers addObject:[self developerWithGiantBombInfo:developer inManagedObjectContext:context]];
    }
    return setOfDevelopers;
    
}

@end
