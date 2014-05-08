//
//  GamesCDTVC.m
//  MyGamesTracker
//
//  Created by MIMO on 04/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GamesCDTVC.h"
#import "Platform.h"
#import "GameCell.h"
#import "GameDatabaseAvailability.h"
#import "NetworkAPIEngine.h"
#import "GameTableViewController.h"
#import "NSString+NSSet.h"
#import "NSMutableAttributedString+TextStyle.h"

@interface GamesCDTVC () 

@property (nonatomic,strong) NSMutableDictionary *covers;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation GamesCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSMutableDictionary *) covers
{
    if (!_covers) {
        _covers = [[NSMutableDictionary alloc] initWithCapacity:[self.fetchedResultsController.fetchedObjects count]];
    }
    return _covers;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Custom Game Cell"];
    
    Game *game = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Title
    [cell.titleLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:game.title withStyle:CellHeadLineCentered]];
    
    // List of Platforms
    NSString *abbreviationPlatforms = [NSString stringListFromNSSet:game.platforms ofItem:@"abbreviation" withSeparator:kStringSeparatorOneLine];
    [cell.platformsLabel setAttributedText:[NSMutableAttributedString attributedStringwithText:abbreviationPlatforms withStyle:CellSubheadlineCentered]];
    
    // Cover
    cell.cellUIImage.contentMode = UIViewContentModeTop;
    [self getCoverWithURL:game.imageURL forImageView:cell.cellUIImage];

    return cell;

}

- (void)getCoverWithURL:(NSString *)url forImageView:(UIImageView *)imageView
{
    imageView.image = nil;
    if (url) {
        UIImage *cover = [self.covers valueForKey:url];
        if (cover) {
            imageView.image = cover;
        } else {
            // Fetch Cover from API
            [[NetworkAPIEngine sharedInstance] fetchImageWithURL:url
                                                    onCompletion:^(UIImage *image, NSError *error) {
                                                        if (!error) {
                                                            [self.covers setValue:image forKey:url];
                                                        } else {
                                                            [self.covers setValue:[UIImage imageNamed:@"coverHI.png"] forKey:url];
                                                        }
                                                        imageView.image = [self.covers valueForKey:url];
                                                    }];
        }

    } else {
        // Scaled Default cover
        UIImage *originalImage = [UIImage imageNamed:@"coverHI.png"];
        UIImage *scaledImage = [UIImage imageWithCGImage:[originalImage CGImage]
                                                   scale:(originalImage.scale * 2.2)
                                             orientation:(originalImage.imageOrientation)];
        imageView.image = scaledImage;
    }
}


#pragma mark - Navigation

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segueIdentifer isEqualToString:@"Show Game"]) {
        if ([vc isKindOfClass:[GameTableViewController class]]) {
            GameTableViewController *ivc = (GameTableViewController *)vc;
            ivc.game = game;
        }
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
