//
//  NetworkAPIEngine.h
//  MyGamesTracker
//
//  Created by MIMO on 06/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking.h>
#import "Game+GiantBomb.h"
#import "Platform+GiantBomb.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchGamesCompletionBlock)(NSArray *games, NSError *error);
typedef void (^FetchGameCompletionBlock)(Game *game, NSError *error);
typedef void (^FetchPlatformsCompletionBlock)(NSArray *platforms, NSError *error);
typedef void (^FetchImageCompletionBlock)(UIImage *image, NSError *error);

@interface NetworkAPIEngine : AFHTTPSessionManager

// AFHTTPSessionManager ofrezca un método que devuelva un singleton
// para que todas las llamadas a la API a través de nuestra implementación
// compartan una misma configuración
+ (instancetype)sharedInstance;

#pragma mark - Games fetching
- (void)fetchGamesWithTitle:(NSString *)title
            andWithPlatform:(NSNumber *)platform
                     offSet:(int) offset
   intoManagedObjectContext:(NSManagedObjectContext *) context
               onCompletion:(FetchGamesCompletionBlock)completionBlock;

- (void)fetchGamesWithId:(NSString *)idAPI
   intoManagedObjectContext:(NSManagedObjectContext *) context
               onCompletion:(FetchGameCompletionBlock)completionBlock;


#pragma mark - Platforms fetching
- (void)fetchPlatformsIntoManagedObjectContext:(NSManagedObjectContext *) context
                                        offSet:(int) offset
                                  onCompletion:(FetchPlatformsCompletionBlock)completionBlock;


- (void)fetchImageWithURL:(NSString *)url
               onCompletion:(FetchImageCompletionBlock)completionBlock;

@end

