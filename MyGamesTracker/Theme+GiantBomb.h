//
//  Theme+GiantBomb.h
//  MyGamesTracker
//
//  Created by MIMO on 19/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "Theme.h"

// typedef del bloque de respuesta para mejorar la legibilidad de la firma del método
typedef void (^FetchThemesCompletionBlock)(NSArray *themes, NSError *error);

extern NSString *const kThemeEntityName;

@interface Theme (GiantBomb)

+ (Theme *)themeWithGiantBombInfo:(NSDictionary *)themeDictionary
           inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSSet *)loadThemesFromGiantBombArray:(NSArray *)themes   // of GiantBomb.com NSDictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context;

@end
