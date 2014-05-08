//
//  GameTableViewController.m
//  MyGamesTracker
//
//  Created by MIMO on 24/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GameTableViewController.h"
#import "ImageViewController.h"
#import "ModelHelper.h"
#import "NSString+Date.h"
#import "NSString+NSSet.h"
#import "NSMutableAttributedString+TextStyle.h"
#import "UIImage+ImageEffects.h"
#import "NetworkAPIEngine.h"
#import "Platform.h"
#import "Developer.h"
#import "Publisher.h"
#import "Franchise.h"
#import "Genre.h"
#import "Theme.h"
#import "Artwork.h"
#import "Item+MyGamesTracker.h"
#import "Tracker+MyGamesTracker.h"
#import "UIColor+RBExtras.h"

static const float kPadding           = 10.0;
static const float kDefaultCellHeight = 22.0;
static const int kNumberOfSections    = 1;
static const int kNumberOfRows        = 10;

@interface GameTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchMyTracker;
@property (weak, nonatomic) IBOutlet UILabel *labelMyTracker;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMyTracker;

@property (weak, nonatomic) IBOutlet UISwitch *switchMyTrackerMustHaves;
@property (weak, nonatomic) IBOutlet UILabel *labelMyTrackerMustHaves;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMyTrackerMustHaves;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releasedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformsLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *developersLabel;
@property (weak, nonatomic) IBOutlet UILabel *developerLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishersLabel;
@property (weak, nonatomic) IBOutlet UILabel *franchiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *franchisesLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *themesLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityCover;

@property (strong, nonatomic) IBOutlet UITableView *gameTable;

@property (strong, nonatomic) Tracker *myTrackerLibrary;
@property (strong, nonatomic) Tracker *myTrackerMustHaves;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end


@implementation GameTableViewController

#pragma mark - Utility class methods
+ (int) heightForCellwithUILabel:(UILabel *)label
{

    CGRect rect;
    rect = [label.attributedText boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return  lrintf(rect.size.height) + (2 * kPadding);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
    [self.gameTable reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    [self.gameTable reloadData];

}

- (void)setGame:(Game *)game
{
    _game = game;
    
    // Set Outlets
    self.context = game.managedObjectContext;
    self.myTrackerLibrary = [Tracker getMyTrackerLibraryinManagedObjectContext:self.context];
    self.myTrackerMustHaves = [Tracker getMyTrackerMustHavesinManagedObjectContext:self.context];
    
    self.title = game.title;
    
    if (!self.game.dateLastUpdated) {   // If it was never updated
        [self updateGame];              // Fetch the rest of the fields of the game
    }
    
    [self updateUI];
    [self.gameTable reloadData];
    
}

- (void) setStyle:(BOOL)isOn ofSwitch:(UISwitch *)sender andLabel:(UILabel *)label andCell:(UITableViewCell *)cell
{
    NSString *textOn  = nil;
    NSString *textOff = nil;
    UIColor *colorOn = nil;
    UIColor *colorOff = nil;

    switch (sender.tag) {
        case 1:
            textOn = NSLocalizedString(@"STRING_IS_IN_MYTRACKERLIBRARY", nil);
            textOff = NSLocalizedString(@"STRING_IS_NOT_IN_MYTRACKERLIBRARY", nil);
            colorOn = [UIColor skyCrayonColor];
            colorOff = [UIColor cantalopeCrayonColor];
            break;
        
        case 2:
            textOn = NSLocalizedString(@"STRING_IS_IN_MYTRACKERMUSTHAVES", nil);
            textOff = NSLocalizedString(@"STRING_IS_NOT_IN_MYTRACKERMUSTHAVES", nil);
            colorOn = [UIColor redSafeWebColor];
            colorOff = [UIColor cantalopeCrayonColor];
            break;
            
        default:
            break;
    }

    if (isOn)
    {
        label.text = textOn;
        cell.backgroundColor = colorOn;
        
    } else {
        label.text = textOff;
        cell.backgroundColor = colorOff;
    }

    label.tag = [GameTableViewController heightForCellwithUILabel:label];
    
}

- (IBAction)changeSwitch:(UISwitch *)sender
{
    
    Tracker *tracker;
    UILabel *label;
    UITableViewCell *cell;
    
    switch (sender.tag) {
        case 1:
            tracker = self.myTrackerLibrary;
            label = self.labelMyTracker;
            cell = self.cellMyTracker;
            break;
            
        case 2:
            tracker = self.myTrackerMustHaves;
            label = self.labelMyTrackerMustHaves;
            cell = self.cellMyTrackerMustHaves;
            break;
            
        default:
            break;
    }
    
    if ([sender isOn]){
        // Insert Game in Tracker
        [Item createItemInTracker:tracker withGame:self.game inManagedObjectContext:self.context];
        [self setStyle:YES ofSwitch:sender andLabel:label andCell:cell];
    } else {
        // Delete Game from Tracker
        [Item deleteItemInTracker:tracker withGame:self.game inManagedObjectContext:self.context];
        [self setStyle:NO ofSwitch:sender andLabel:label andCell:cell];
    }

}

- (void) updateGame
{
    [self.activityCover startAnimating];
    
    // Game's info is not complete then Fetch All info of the Game from API
    [[NetworkAPIEngine sharedInstance] fetchGamesWithId:self.game.idAPI
                               intoManagedObjectContext:self.game.managedObjectContext
                                           onCompletion:^(Game *fetchGame, NSError *error) {
                                               if (!error) {
                                                   self.game = fetchGame;
                                               } else {
                                                   [ModelHelper displayAlertError:error];
                                               }
                                           }];
}

- (void)updateUI
{
    
    // Labels
    self.developerLabel.text = NSLocalizedString(@"STRING_DEVELOPER", nil);
    self.publisherLabel.text = NSLocalizedString(@"STRING_PUBLISHER", nil);
    self.franchiseLabel.text = NSLocalizedString(@"STRING_FRANCHISE", nil);
    self.genreLabel.text = NSLocalizedString(@"STRING_GENRE", nil);
    self.themeLabel.text = NSLocalizedString(@"STRING_THEME", nil);
    
    // Switch Tracker Library
    if ([Item isGame:self.game inTracker:self.myTrackerLibrary inManagedObjectContext:self.context]) {
        [self.switchMyTracker setOn:YES];
        [self setStyle:YES ofSwitch:self.switchMyTracker andLabel:self.labelMyTracker andCell:self.cellMyTracker];
    } else {
        [self.switchMyTracker setOn:NO];
        [self setStyle:NO ofSwitch:self.switchMyTracker andLabel:self.labelMyTracker andCell:self.cellMyTracker];
    }
    
    // Switch Tracker Must-Haves
    if ([Item isGame:self.game inTracker:self.myTrackerMustHaves inManagedObjectContext:self.context]) {
        [self.switchMyTrackerMustHaves setOn:YES];
        [self setStyle:YES ofSwitch:self.switchMyTrackerMustHaves andLabel:self.labelMyTrackerMustHaves andCell:self.cellMyTrackerMustHaves];
    } else {
        [self.switchMyTrackerMustHaves setOn:NO];
        [self setStyle:NO ofSwitch:self.switchMyTrackerMustHaves andLabel:self.labelMyTrackerMustHaves andCell:self.cellMyTrackerMustHaves];
    }
    
    // Title
    [self.titleLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:self.game.title withStyle:CellHeadline]];
    self.titleLabel.tag = [GameTableViewController heightForCellwithUILabel:self.titleLabel];
    
    // Release Date
    NSString *stringDate = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"STRING_RELEASE_DATE", nil), (self.game.releaseDate) ? [NSString stringDateFromDatewithFormatUserLocate:self.game.releaseDate] : NSLocalizedString(@"STRING_NO_DATA", nil)];
    [self.releasedDateLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:stringDate withStyle:CellSubheadline]];
    self.releasedDateLabel.tag = [GameTableViewController heightForCellwithUILabel:self.releasedDateLabel];
    
    // Platforms
    NSString *namePlatforms = [NSString stringListFromNSSet:self.game.platforms ofItem:@"name" withSeparator:kStringSeparatorOneLine];
    [self.platformsLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:namePlatforms withStyle:CellSubheadline]];
    self.platformsLabel.tag = [GameTableViewController heightForCellwithUILabel:self.platformsLabel];
    
    // Info
    [self.infoLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:(self.game.summary) ? self.game.summary : NSLocalizedString(@"STRING_NO_DATA", nil) withStyle:CellBody]];
    self.infoLabel.tag = [GameTableViewController heightForCellwithUILabel:self.infoLabel];
    
    // Developers
    NSString *nameDevelopers = [NSString stringListFromNSSet:self.game.developers ofItem:@"name" withSeparator:kStringSeparatorManyLines];
    [self.developersLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:nameDevelopers withStyle:CellBody]];
    self.developersLabel.tag = [GameTableViewController heightForCellwithUILabel:self.developersLabel];
    
    // Publishers
    NSString *namePublishers = [NSString stringListFromNSSet:self.game.publishers ofItem:@"name" withSeparator:kStringSeparatorManyLines];
    [self.publishersLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:namePublishers withStyle:CellBody]];
    self.publishersLabel.tag = [GameTableViewController heightForCellwithUILabel:self.publishersLabel];
    
    // Franchises
    NSString *nameFranchises = [NSString stringListFromNSSet:self.game.franchises ofItem:@"name" withSeparator:kStringSeparatorManyLines];
    [self.franchisesLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:nameFranchises withStyle:CellBody]];
    self.franchisesLabel.tag = [GameTableViewController heightForCellwithUILabel:self.franchisesLabel];
    
    // Themes
    NSString *nameThemes = [NSString stringListFromNSSet:self.game.themes ofItem:@"name" withSeparator:kStringSeparatorManyLines];
    [self.themesLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:nameThemes withStyle:CellBody]];
    self.themesLabel.tag = [GameTableViewController heightForCellwithUILabel:self.themesLabel];
    
    // Genres
    NSString *nameGenres = [NSString stringListFromNSSet:self.game.genres ofItem:@"name" withSeparator:kStringSeparatorManyLines];
    [self.genresLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:nameGenres withStyle:CellBody]];
    self.genresLabel.tag = [GameTableViewController heightForCellwithUILabel:self.genresLabel];

}

- (void)getCoverWithURL:(NSString *)url forImageView:(UIImageView *)imageView
{
    imageView.image = nil;
    if (url) {
        // Fetch Cover from API
        [[NetworkAPIEngine sharedInstance] fetchImageWithURL:url
                                                onCompletion:^(UIImage *image, NSError *error) {
                                                    if (!error) {
                                                        imageView.image = image;
                                                    } else {
                                                        imageView.image = [UIImage imageNamed:@"coverHI.png"];
                                                    }
                                                    
                                                }];
    } else {
        imageView.image = [UIImage imageNamed:@"coverHI.png"];
    }
}

#pragma mark - Table view data source
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set cell's background: cover of the game
    if ((indexPath.section == 0) && (indexPath.row == 2)) {
        
        if (self.game.imageSuperURL) {
            
            [self.activityCover startAnimating];
            
            // Fetch Cover from API
            [[NetworkAPIEngine sharedInstance] fetchImageWithURL:self.game.imageSuperURL
                                                    onCompletion:^(UIImage *image, NSError *error) {
                                                        if (!error) {
                                                            UIImage *scaledImage = [UIImage imageWithImageOriginal:image convertToWidth:self.view.frame.size.width];
                                                            [cell setBackgroundColor:[UIColor colorWithPatternImage:scaledImage]];
                                                            [self.activityCover stopAnimating];
                                                            
                                                        }
                                                        
                                                    }];
        } else {
            [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"coverHI.png"]]];
        }

    }
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = kDefaultCellHeight;

    if (indexPath.section == 0) {
        switch (indexPath.row) {

            case 0:
                // Add my Tracker Library
                cellHeight = self.labelMyTracker.tag;
                break;
            
            case 1:
                // Add my Tracker Must-Haves
                cellHeight = self.labelMyTrackerMustHaves.tag;
                break;
                
            case 2:
                // Cover
                cellHeight = self.titleLabel.tag + self.releasedDateLabel.tag + self.platformsLabel.tag;
                break;
                
            case 3:
                // Title
                cellHeight = self.titleLabel.tag + self.releasedDateLabel.tag + self.platformsLabel.tag - kPadding;
                break;
                
            case 4:
                // Info
                cellHeight = self.infoLabel.tag;
                break;
            
            case 5:
                // Developers
                cellHeight = self.developersLabel.tag;
                break;
            
            case 6:
                // Publishers
                cellHeight = self.publishersLabel.tag;
                break;
            
            case 7:
                // Franchises
                cellHeight = self.franchisesLabel.tag;
                break;
            
            case 8:
                // Themes
                cellHeight = self.themesLabel.tag;
                break;
            
            case 9:
                // Genres
                cellHeight = self.genresLabel.tag;
                break;
                
            default:
                cellHeight = kDefaultCellHeight;
                break;
        }
    }
    
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfRows;
}

#pragma mark - Navigation
- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    if ([segueIdentifer isEqualToString:@"Show Cover"]) {
        if ([vc isKindOfClass:[ImageViewController class]]) {
            ImageViewController *ivc = (ImageViewController *)vc;
            ivc.imageURL = self.game.imageSuperURL;
            ivc.title = [NSString stringWithFormat:@"%@ %@",self.game.title, NSLocalizedString(@"STRING_COVER", nil)];
        }
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if  (([identifier isEqualToString:@"Show Cover"]) && (self.game.imageSuperURL)) {
        return YES;
    } else {
        return  NO;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
    }
}

@end
