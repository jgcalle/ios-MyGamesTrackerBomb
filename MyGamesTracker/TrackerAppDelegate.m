//
//  TrackerAppDelegate.m
//  MyGamesTracker
//
//  Created by MIMO on 03/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "TrackerAppDelegate.h"
#import "TrackerAppDelegate+MOC.h"
#import "GameDatabaseAvailability.h"
#import "UIImage+ImageEffects.h"

@interface TrackerAppDelegate() <NSXMLParserDelegate>

@property (strong, nonatomic) NSManagedObjectContext *gameDatabaseContext;

@end

@implementation TrackerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.gameDatabaseContext = [self createMainQueueManagedObjectContext];
    return YES;
}

- (void) setGameDatabaseContext:(NSManagedObjectContext *)gameDatabaseContext
{
    _gameDatabaseContext = gameDatabaseContext;
    
    // Send a notification with the context in userInfo parameter
    NSDictionary *userInfo = self.gameDatabaseContext ? @{ GameDatabaseAvailabilityContext: self.gameDatabaseContext }: nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:GameDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}

@end