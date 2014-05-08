//
//  Publisher+GiantBomb.m
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Publisher+GiantBomb.h"
#import "GiantBombFetcher.h"

NSString *const kPublisherEntityName = @"Publisher";

@implementation Publisher (GiantBomb)

+ (Publisher *)publisherWithGiantBombInfo:(NSDictionary *)publisherDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context
{
    Publisher *publisher = nil;
    
    NSString *id = [publisherDictionary valueForKeyPath:GIANTBOMB_PUBLISHER_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kPublisherEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        
        // NSError
        NSLog(@"Fetch Request error (code %li), %@", (long)[error code], [error userInfo]);
        
    } else if ([matches count]) {
        
        publisher = [matches firstObject];
        
    } else {
        
        publisher = [NSEntityDescription insertNewObjectForEntityForName:kPublisherEntityName inManagedObjectContext:context];
        
        NSString *data = nil;
        
        // Id
        publisher.id = @([id intValue]);
        
        // Name
        data = [publisherDictionary valueForKeyPath:GIANTBOMB_PUBLISHER_NAME];
        if (![data isKindOfClass:[NSNull class]]) publisher.name = data;
        
        // Site Details URL
        data = [publisherDictionary valueForKeyPath:GIANTBOMB_PUBLISHER_SITE_DETAILS_URL];
        if (![data isKindOfClass:[NSNull class]]) publisher.siteDetailsURL = data;
        
    }
    
    return publisher;
    
}

+ (NSSet *)loadPublishersFromGiantBombArray:(NSArray *)publishers   // of GiantBomb.com NSDictionary
                     inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableSet* setOfPublishers = [NSMutableSet set];
    for (NSDictionary *publisher in publishers) {
        [setOfPublishers addObject:[self publisherWithGiantBombInfo:publisher inManagedObjectContext:context]];
    }
    return setOfPublishers;
    
}

@end
