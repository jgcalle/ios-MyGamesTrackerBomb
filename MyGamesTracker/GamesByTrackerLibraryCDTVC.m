//
//  GamesByTrackerLibraryCDTVC.m
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GamesByTrackerLibraryCDTVC.h"
#import "GameDatabaseAvailability.h"
#import "Tracker+MyGamesTracker.h"
#import "Item+MyGamesTracker.h"
#import "Game+GiantBomb.h"

@interface GamesByTrackerLibraryCDTVC ()

@property (strong, nonatomic) Tracker *trackerLibrary;

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIView *noResultsView;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;

@end

@implementation GamesByTrackerLibraryCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Properties
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Localized Strings
    self.emptyListLabel.text = NSLocalizedString(@"STRING_NOT_FOUND_RESULTS", nil);
}

- (void)setTitleFetchedObjects:(int)count
{
    if (count > 0) {
        [self.noResultsView removeFromSuperview];
        NSString *title = [NSString stringWithFormat:(count > 1) ? NSLocalizedString(@"STRING_FOUND_GAMES", nil) : NSLocalizedString(@"STRING_FOUND_GAME", nil), count];
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"STRING_TITLE_TABLE", nil),title];
    } else {
        self.noResultsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.table insertSubview:self.noResultsView belowSubview:self.table];
        self.navigationItem.title = NSLocalizedString(@"STRING_TITLE_TABLE", nil);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleFetchedObjects:(int) [self.fetchedResultsController.fetchedObjects count]];
    [self.table reloadData];
}

- (void)awakeFromNib
{
    // Awaiting a notification with the context
    [[NSNotificationCenter defaultCenter] addObserverForName:GameDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[GameDatabaseAvailabilityContext];
                                                  }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self setupFetchedResultsController];
}


- (void)setupFetchedResultsController
{
    
    if (self.managedObjectContext) {
        
        self.trackerLibrary = [Tracker getMyTrackerLibraryinManagedObjectContext:self.managedObjectContext];

        if (self.trackerLibrary) {

            // Instantiate the request for this specific entity (table)
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGameEntityName];
            
            // Build the predicate string
            request.predicate = [NSPredicate predicateWithFormat:@"items.tracker.name CONTAINS[cd] %@", self.trackerLibrary.name];
            
            // Set the sort descriptors for the query
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kGameEntityTitleAttributeName
                                                                      ascending:YES
                                                                       selector:@selector(localizedStandardCompare:)]];
            // And execute the fetch request on the context
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:self.managedObjectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
            
        }
    } else {
        self.fetchedResultsController = nil;
        [self setTitleFetchedObjects:0];
    }
}

@end
