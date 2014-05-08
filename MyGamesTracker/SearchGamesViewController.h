//
//  SearchGamesViewController.h
//  MyGamesTracker
//
//  Created by MIMO on 06/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGamesViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSMutableArray *platforms; // of Platforms

@end
