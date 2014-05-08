//
//  Franchise+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Franchise+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kFranchiseEntityName = @"Franchise";

@implementation Franchise (GiantBomb)

+ (Franchise *)franchiseWithGiantBombInfo:(NSDictionary *)franchiseDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Franchise *franchise = nil;
    
    NSString *id = [franchiseDictionary valueForKeyPath:GIANTBOMB_FRANCHISE_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kFranchiseEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        franchise = [matches firstObject];
    
    } else {
        
        franchise = [NSEntityDescription insertNewObjectForEntityForName:kFranchiseEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        franchise.id = @([id intValue]);
        
        // Name
        data = [franchiseDictionary valueForKeyPath:GIANTBOMB_FRANCHISE_NAME];
        if (![data isKindOfClass:[NSNull class]]) franchise.name = data;
        
        
        // Site Details URL
        data = [franchiseDictionary valueForKeyPath:GIANTBOMB_FRANCHISE_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) franchise.siteDetailsURL = data;
        
    }
    
    return franchise;
    
}

+ (NSSet *)loadFranchisesFromGiantBombArray:(NSArray *)franchises   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfFranchises = [NSMutableSet set];
    for (NSDictionary *franchise in franchises) {
        [setOfFranchises addObject:[self franchiseWithGiantBombInfo:franchise inManagedObjectContext:context]];
    }
    return setOfFranchises;
    
}

@end