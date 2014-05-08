//
//  GamesBySearchCDTVC.m
//  MyGamesTracker
//
//  Created by MIMO on 13/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GamesBySearchCDTVC.h"
#import "Game+GiantBomb.h"

@interface GamesBySearchCDTVC ()

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *noResultsView;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;

@end

@implementation GamesBySearchCDTVC

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
        self.navigationItem.title = [NSString stringWithFormat:(count > 1) ? NSLocalizedString(@"STRING_FOUND_GAMES", nil) : NSLocalizedString(@"STRING_FOUND_GAME", nil), count];
    } else {
        self.noResultsView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.table insertSubview:self.noResultsView belowSubview:self.table];
        self.navigationItem.title = NSLocalizedString(@"STRING_TITLE_SEARCH_TABLE", nil);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleFetchedObjects:(int) [self.fetchedResultsController.fetchedObjects count]];
    [self.table reloadData];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self setupFetchedResultsController];
}

- (NSDictionary *)gameQuery
{
    if (!_gameQuery) {
        _gameQuery  = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil, @"title", nil, @"platform", nil, @"platformName", nil];
    }
    return _gameQuery;
}

- (void)setupFetchedResultsController
{
    
    if (self.managedObjectContext) {
        
        // Instantiate the request for this specific entity (table)
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGameEntityName];

        
        // Build the predicate string based on gameQuery property
        NSMutableArray *fields = [NSMutableArray arrayWithCapacity:2];
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:2];
        
        NSString *title = [self.gameQuery valueForKey:@"title"];
        if (title && title.length > 0) {
            [fields addObject:@"title LIKE[cd] %@"];
            [values addObject:[NSString stringWithFormat:@"*%@*",title]];
            //self.title = title;
        }
        
        NSString *platform = [self.gameQuery valueForKey:@"platformName"];
        if (platform && platform.length > 0) {
            [fields addObject:@"platforms.name CONTAINS[cd] %@"];
            [values addObject:platform];
            //self.title = [self.title stringByAppendingString:[NSString stringWithFormat:@" (%@) ", [self.gameQuery valueForKey:@"platformName"]]];
        }

        NSMutableString *query = [NSMutableString stringWithCapacity:128];
        for (int i = 0 ; i < fields.count ; ++i) {
            [query appendString:fields[i]];
            if (i < fields.count - 1) {
                [query appendString:@" AND "];
            }
        }
        
        // Set the desired predicate for the query
        request.predicate = [NSPredicate predicateWithFormat:query
                                               argumentArray:values];
        
        // Set the sort descriptors for the query
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kGameEntityTitleAttributeName
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        // And execute the fetch request on the context
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
        // Set title
        int numberOfGames = (int) [self.fetchedResultsController.fetchedObjects count];
        if (numberOfGames > 0) {
            self.navigationItem.title = [NSString stringWithFormat:(numberOfGames > 1) ? NSLocalizedString(@"STRING_FOUND_GAMES", nil) : NSLocalizedString(@"STRING_FOUND_GAME", nil), numberOfGames];
        }
        
    } else {
        self.fetchedResultsController = nil;
        [self setTitleFetchedObjects:0];
    }
}

@end
