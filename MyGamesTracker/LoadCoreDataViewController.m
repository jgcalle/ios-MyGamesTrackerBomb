//
//  LoadCoreDataViewController.m
//  MyGamesTracker
//
//  Created by MIMO on 17/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "LoadCoreDataViewController.h"
#import "NetworkAPIEngine.h"
#import "GameDatabaseAvailability.h"
#import "Platform+GiantBomb.h"
#import "SearchGamesViewController.h"
#import "ModelHelper.h"

@interface LoadCoreDataViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelPlatforms;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityPlatforms;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

@property (strong,nonatomic) NSArray *platforms;

@end


@implementation LoadCoreDataViewController

- (NSArray *) platforms
{
    if (!_platforms) {
        _platforms = [[NSArray alloc] init];
    }
    return _platforms;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

}


- (void)viewDidAppear:(BOOL)animated
{
    //UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchGamesViewController"];
    //[self.navigationController pushViewController:vc animated:NO];
    
    [self nextController];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set Outlets
    self.retryButton.hidden = YES;
    self.labelPlatforms.text = NSLocalizedString(@"STRING_LOADING_PLATFORMS", nil);
    [self.retryButton setTitle:NSLocalizedString(@"STRING_BUTTON_RETRY", nil) forState:UIControlStateNormal];
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"STRING_SEARCH", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"STRING_TITLE_TABLE", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"STRING_TITLE_TABLE_MUST", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:NSLocalizedString(@"STRING_ABOUT", nil)];
    
    
    // Initialization of importants entities
    [self initializationCoreDataPlatforms];
    
}


- (void) initializationCoreDataPlatforms
{
    
    [self.activityPlatforms startAnimating];
    
    [Platform fetchAllPlatformsIntoManagedObjectContext:self.managedObjectContext
                                           onCompletion:^(NSArray *platforms, NSError *error) {
                                               if (!error) {
                                                   self.labelPlatforms.text = [NSString stringWithFormat:NSLocalizedString(@"STRING_LOADED_PLATFORMS", nil),(unsigned long)[platforms count]];
                                                   self.platforms = platforms;
                                                   [self nextController];
                                                   
                                               } else {
                                                   
                                                   self.labelPlatforms.text = NSLocalizedString(@"STRING_NOT_LOADED_PLATFORMS", nil);
                                                   [ModelHelper displayAlertError:error];
                                                   self.retryButton.hidden = NO;
                                                   
                                               }
                                               [self.activityPlatforms stopAnimating];
                                           }];
    
    
}

- (IBAction)retry {
    
    self.retryButton.hidden = YES;
    [self initializationCoreDataPlatforms];
    
}

- (void) nextController
{
    if ([self.platforms count]) {
        [self performSegueWithIdentifier:@"Games Search" sender:self];
    }
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Games Search"]) {
        
        if ([segue.destinationViewController isKindOfClass:[SearchGamesViewController class]]) {
            SearchGamesViewController *sgvc = (SearchGamesViewController *) segue.destinationViewController;
            sgvc.managedObjectContext = self.managedObjectContext;
            sgvc.platforms = [[NSMutableArray alloc] initWithArray:self.platforms];
        }
        
    }
    
}

@end
