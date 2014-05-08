//
//  NetworkAPIEngine.m
//  MyGamesTracker
//
//  Created by MIMO on 06/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "NetworkAPIEngine.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "GiantBombFetcher.h"
#import "ModelHelper.h"

@implementation NetworkAPIEngine

#pragma mark - Singleton instantiation for NetworkApiEngine
+ (instancetype)sharedInstance
{
    static NetworkAPIEngine *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Network activity indicator manager setup
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        // Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{ @"User-Agent" : @"iOS Client" };
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024     // 10MB. memory cache
                                                          diskCapacity:50 * 1024 * 1024     // 50MB. on disk cache
                                                              diskPath:nil];
        
        sessionConfiguration.URLCache = cache;
        //sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        sessionConfiguration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        // Initialize the session
        _sharedInstance = [[NetworkAPIEngine alloc] initWithBaseURL:[NSURL URLWithString:GIANTBOMB_BASE_URL] sessionConfiguration:sessionConfiguration];
    });
    
    return _sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (!self) return nil;
    
    // Session additional settings
    // self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // Reachability setup
    //[self.reachabilityManager startMonitoring];
    
    return self;
}


#pragma mark - Platforms fetching
- (void)fetchPlatformsIntoManagedObjectContext:(NSManagedObjectContext *)context
                                        offSet:(int)offset
                                  onCompletion:(FetchPlatformsCompletionBlock)completionBlock
{
    NSString *path = [GiantBombFetcher pathForPlatformsByName:nil andOffset:offset];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *platforms = [[NSMutableArray alloc] initWithObjects:responseObject, nil];
        
        // Get platforms request
        platforms = [(NSDictionary *)responseObject valueForKeyPath:GIANTBOMB_RESULTS];
        
        // Show status code for the result of the request send by GiantBomb
        int statusCode = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_STATUS_CODE] intValue];
        
        if ((context) && (platforms) && (statusCode == GiantBombStatusCodeOk)) {
            
            // Add platforms
            platforms = (NSMutableArray *)[Platform loadPlatformsFromGiantBombArray:platforms inManagedObjectContext:context];
            
            // Save Context
            NSError *error = nil;
            [context save:&error];
            
            if (!error) {
                
                // GiantBomb only returns a max number of results per request
                int page_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_NUMBER_ITEM] intValue];
                int total_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_NUMBER_ITEM_TOTAL] intValue];
                int offset_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_OFFSET] intValue];
                int new_offset = offset_results + page_results;
                
                // Had it got all platforms?
                if ( new_offset < total_results) {
                    
                    // No, It has to request platforms remainder
                    [self fetchPlatformsIntoManagedObjectContext:context
                                                          offSet:new_offset
                                                    onCompletion:^(NSArray *listPlatforms, NSError *error) {
                                                        if (!error) {
                                                            if (completionBlock) completionBlock(platforms, nil);
                                                        } else {
                                                            if (completionBlock) completionBlock(nil, error);
                                                        }
                                                    }];
                } else {
                    // Yes, it got all platforms
                    if (completionBlock) completionBlock(platforms, nil);
                }
            } else {
                completionBlock(nil, error);
            }
            
        } else {

            NSError *error = [NSError errorWithDomain:NSGamesTrackerErrorDomain code:statusCode userInfo:nil];
            completionBlock(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil, error);
    }];
    
}

#pragma mark - Games fetching

- (void)fetchGamesWithTitle:(NSString *)title
            andWithPlatform:(NSNumber *)platform
                     offSet:(int)offset
   intoManagedObjectContext:(NSManagedObjectContext *)context
               onCompletion:(FetchGamesCompletionBlock)completionBlock
{
    NSString *path = [GiantBombFetcher pathForGamesByTitle:title andPlatform:platform andOffset:offset];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // Get games request
        NSMutableArray *games = [[NSMutableArray alloc] initWithObjects:responseObject, nil];
        games = [(NSDictionary *)responseObject valueForKeyPath:GIANTBOMB_RESULTS];
        
        // Show status code for the result of the request send by GiantBomb
        int statusCode = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_STATUS_CODE] intValue];
        
        if ((context) && (games) && (statusCode == GiantBombStatusCodeOk)) {
            
            // Add Games
            games = (NSMutableArray *)[Game loadGamesFromGiantBombArray:games inManagedObjectContext:context];
            
            // Save Context
            NSError *error = nil;
            [context save:&error];
            
            if (!error) {
                
                // GiantBomb only returns a max number of results per request
                int page_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_NUMBER_ITEM] intValue];
                int total_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_NUMBER_ITEM_TOTAL] intValue];
                int offset_results = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_OFFSET] intValue];
                int new_offset = offset_results + page_results;
               
                // Had it got all games?
                if ( new_offset < total_results) {
                    
                    // No, It has to request games remainder
                    [self fetchGamesWithTitle:title
                              andWithPlatform:platform
                                       offSet:new_offset
                     intoManagedObjectContext:context
                                 onCompletion:^(NSArray *games, NSError *error) {
                                     if (!error) {
                                         if (completionBlock) completionBlock(games, nil);
                                     } else {
                                         if (completionBlock) completionBlock(nil, error);
                                     }
                                 }];
                } else {
                    // Yes, it got all games
                    if (completionBlock) completionBlock(games, nil);
                }
            } else {
                completionBlock(nil, error);
            }
            
        } else {

            NSError *error = [NSError errorWithDomain:NSGamesTrackerErrorDomain code:statusCode userInfo:nil];
            completionBlock(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil, error);
    }];
    
}

- (void)fetchGamesWithId:(NSString *)idAPI
intoManagedObjectContext:(NSManagedObjectContext *) context
            onCompletion:(FetchGameCompletionBlock)completionBlock
{
   
    NSString *path = [GiantBombFetcher pathForGamesById:idAPI];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // Get game request
        NSDictionary *fetchGame = [(NSDictionary *)responseObject valueForKeyPath:GIANTBOMB_RESULTS];
        
        // Show status code for the result of the request send by GiantBomb
        int statusCode = [[(NSNumber *)responseObject valueForKeyPath:GIANTBOMB_RESULTS_STATUS_CODE] intValue];
        
        if ((context) && (fetchGame) && (statusCode == GiantBombStatusCodeOk)) {
            
            // Update game data
            Game *game = [Game gameWithGiantBombInfo:fetchGame action:updateGame inManagedObjectContext:context];
        
            // Save Context
            NSError *error = nil;
            [context save:&error];
            if (!error) {
                if (completionBlock) completionBlock(game, nil);
            } else {
                if (completionBlock) completionBlock(nil, error);
            }
        } else {
        
            NSError *error = [NSError errorWithDomain:NSGamesTrackerErrorDomain code:statusCode userInfo:nil];
            completionBlock(nil, error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock) completionBlock(nil, error);
    }];
    
    
}


#pragma mark - Fetch a Cover Game
- (void)fetchImageWithURL:(NSString *)url
             onCompletion:(FetchImageCompletionBlock)completionBlock
{

        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (completionBlock) completionBlock(responseObject, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (completionBlock) completionBlock(nil, error);
            
        }];
        [requestOperation start];
    
}

@end
