//
//  Game.h
//  MyGamesTracker
//
//  Created by MIMO on 06/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artwork, Developer, Franchise, Genre, Item, Platform, Publisher, Theme;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSDate * dateLastUpdated;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * idAPI;
@property (nonatomic, retain) NSString * imageSuperURL;
@property (nonatomic, retain) NSString * imageThumbURL;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * siteDetailsURL;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *developers;
@property (nonatomic, retain) NSSet *franchises;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *platforms;
@property (nonatomic, retain) NSSet *publishers;
@property (nonatomic, retain) NSSet *themes;
@property (nonatomic, retain) NSSet *items;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addDevelopersObject:(Developer *)value;
- (void)removeDevelopersObject:(Developer *)value;
- (void)addDevelopers:(NSSet *)values;
- (void)removeDevelopers:(NSSet *)values;

- (void)addFranchisesObject:(Franchise *)value;
- (void)removeFranchisesObject:(Franchise *)value;
- (void)addFranchises:(NSSet *)values;
- (void)removeFranchises:(NSSet *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addImagesObject:(Artwork *)value;
- (void)removeImagesObject:(Artwork *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addPlatformsObject:(Platform *)value;
- (void)removePlatformsObject:(Platform *)value;
- (void)addPlatforms:(NSSet *)values;
- (void)removePlatforms:(NSSet *)values;

- (void)addPublishersObject:(Publisher *)value;
- (void)removePublishersObject:(Publisher *)value;
- (void)addPublishers:(NSSet *)values;
- (void)removePublishers:(NSSet *)values;

- (void)addThemesObject:(Theme *)value;
- (void)removeThemesObject:(Theme *)value;
- (void)addThemes:(NSSet *)values;
- (void)removeThemes:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
