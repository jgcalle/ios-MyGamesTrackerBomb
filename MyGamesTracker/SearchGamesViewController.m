//
//  SearchGamesViewController.m
//  MyGamesTracker
//
//  Created by MIMO on 06/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "SearchGamesViewController.h"
#import "SimpleTableViewController.h"
#import "GamesBySearchCDTVC.h"
#import "NetworkAPIEngine.h"
#import "GameDatabaseAvailability.h"
#import "Platform.h"
#import "GiantBombFetcher.h"
#import "ModelHelper.h"

@interface SearchGamesViewController () <UITextFieldDelegate, SimpleTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *titleGameTextField;
@property (weak, nonatomic) IBOutlet UITextField *platformTextField;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;

@property (weak, nonatomic) IBOutlet UIButton *platformButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSMutableDictionary *gameQuery;
@property (strong, nonatomic) NSMutableArray *platformsNames;

@end

@implementation SearchGamesViewController

- (void)setPlatforms:(NSMutableArray *)platforms
{
    _platforms = platforms;
    
    for (Platform *platform in self.platforms) {
        [self.platformsNames addObject:platform.name];
    }
    
}

- (NSMutableArray *) platformsNames
{
    if (!_platformsNames) {
        _platformsNames = [[NSMutableArray alloc] initWithCapacity:[self.platforms count]];
    }
    return _platformsNames;
}

- (NSDictionary *)gameQuery
{
    if (!_gameQuery) {
        _gameQuery  = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil, @"title", nil, @"platform", nil, @"platformName", nil];
    }
    return _gameQuery;
}

- (void) setTitleGameTextField:(UITextField *)titleGameTextField
{
    _titleGameTextField = titleGameTextField;
    self.titleGameTextField.delegate = self;
    
    // Set MagnifyingGlass Icon to search text field
    UILabel *magnifyingGlass = [[UILabel alloc] init];
    [magnifyingGlass setText:[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"]];
    [magnifyingGlass sizeToFit];
    [self.titleGameTextField setLeftView:magnifyingGlass];
    [self.titleGameTextField setLeftViewMode:UITextFieldViewModeAlways];
    
}

- (void) setPlatformTextField:(UITextField *)platformTextField
{
    _platformTextField = platformTextField;
    self.platformTextField.delegate = self;
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

    // Set Outlets
    self.titleGameTextField.placeholder = NSLocalizedString(@"STRING_TEXTFIELD_GAME", nil);
    self.platformTextField.placeholder = NSLocalizedString(@"STRING_ANY_PLATFORMS", nil);
    self.footerLabel.text = NSLocalizedString(@"STRING_FOOTER", nil);
    
    // Localized Strings
    [self.searchButton setTitle:NSLocalizedString(@"STRING_SEARCH", nil) forState:UIControlStateNormal];
    [self.platformButton setTitle:NSLocalizedString(@"STRING_PLATFORM", nil) forState:UIControlStateNormal];
    [self setPlaformButtonStyle: NSLocalizedString(@"STRING_ANY_PLATFORMS", nil)];
    self.navigationItem.title = NSLocalizedString(@"STRING_SEARCH_GAMES", nil);
        
    // Hidden back button from navigation controller
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=nil;
  
}

- (void) setPlaformButtonStyle:(NSString *)title
{

    if ([title isEqualToString: NSLocalizedString(@"STRING_ANY_PLATFORMS", nil)])
    {
        self.platformTextField.text = @"";
    } else {
        self.platformTextField.text = title;
    }
    
}


- (IBAction)searchGames {
    
    if ([self.titleGameTextField hasText] && self.titleGameTextField.text.length >= MINIMUN_STRING_SEARCH_LENGTH) {
        
        [self.activityIndicator startAnimating];
        
        // Set values for gamesQuery NSDictionary
        [self.gameQuery setValue:[self.titleGameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] forKey:@"title"];

        
        // Fetch Games from API
        [[NetworkAPIEngine sharedInstance] fetchGamesWithTitle:[self.gameQuery valueForKey:@"title"]
                                               andWithPlatform:[self.gameQuery valueForKey:@"platform"]
                                                     offSet:0
                                      intoManagedObjectContext:self.managedObjectContext
                                                  onCompletion:^(NSArray *games, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (!error) {
                if ([games count] > 0) {
                    [self performSegueWithIdentifier:@"Games Search Results" sender:self];
                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STRING_INFO", nil)
                                                message:NSLocalizedString(@"STRING_NO_FOUND_RESULTS", nil)
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                      otherButtonTitles:nil]
                     show];
                }
                
                
            } else {
                [ModelHelper displayAlertError:error];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STRING_INFO", nil)
                                    message:[NSString stringWithFormat: NSLocalizedString(@"STRING_SEARCH_LENGTH", nil), MINIMUN_STRING_SEARCH_LENGTH]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"STRING_OK", nil)
                          otherButtonTitles:nil]
         show];
    }
}

- (IBAction)selectPlatform {
    
    UINavigationController *navigationController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SimpleTableVC"];
    
    SimpleTableViewController *tableViewController = (SimpleTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
    
    tableViewController.tableData = self.platformsNames;
    tableViewController.navigationItem.title = NSLocalizedString(@"STRING_PLATFORMS", nil);
    tableViewController.title = NSLocalizedString(@"STRING_PLATFORMS", nil);
    tableViewController.oldItemSelected = self.platformTextField.text;
    tableViewController.delegate = self;
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

#pragma mark - Method SimpleTableViewControllerDelegate
- (void)itemSelectedatRow:(NSInteger)row inSimpleTableTitle:(NSString *)title
{

    Platform *platform = [self.platforms objectAtIndex:row];
    [self.gameQuery setValue:platform.id forKey:@"platform"];
    [self.gameQuery setValue:platform.name forKey:@"platformName"];
    
    [self setPlaformButtonStyle:[self.gameQuery valueForKey:@"platformName"]];

}


#pragma mark - Methods Keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchGames];
    return YES;
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL isEditable = YES;
    if (textField == self.platformTextField) {
        isEditable = NO;
    }
    return isEditable;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.titleGameTextField isFirstResponder] && [touch view] != self.titleGameTextField) {
        [self.titleGameTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
 

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.platformTextField) [self clearPlatformTextField];
    return YES;
}

- (void)clearPlatformTextField
{
    [self.gameQuery setValue:nil forKey:@"platform"];
    [self.gameQuery setValue:nil forKey:@"platformName"];
}



#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Games Search Results"]) {
        
        if ([segue.destinationViewController isKindOfClass:[GamesCDTVC class]]) {
            GamesBySearchCDTVC *gbscdtvc = (GamesBySearchCDTVC *) segue.destinationViewController;
            gbscdtvc.gameQuery = self.gameQuery;
            gbscdtvc.managedObjectContext = self.managedObjectContext;
        }
        
    }
}

@end
