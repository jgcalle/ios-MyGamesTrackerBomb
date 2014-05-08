//
//  GiantBombFetcher.h
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

// key paths to general values of Giantbomb.com results
#define GIANTBOMB_RESULTS_LIMIT @"limit"
#define GIANTBOMB_RESULTS_OFFSET @"offset"
#define GIANTBOMB_RESULTS_ERROR @"error"
#define GIANTBOMB_RESULTS_STATUS_CODE @"status_code"
#define GIANTBOMB_RESULTS_NUMBER_ITEM @"number_of_page_results"
#define GIANTBOMB_RESULTS_NUMBER_ITEM_TOTAL @"number_of_total_results"

// key paths to entities at top-level of GiantBomb.com results
#define GIANTBOMB_RESULTS @"results"

// keys (paths) to values in a game
#define GIANTBOMB_GAMES_ID @"id"
#define GIANTBOMB_GAMES_ID_API @"api_detail_url"
#define GIANTBOMB_GAMES_IMAGE @"image"
#define GIANTBOMB_GAMES_INFO @"description"
#define GIANTBOMB_GAMES_SUMMARY @"deck"
#define GIANTBOMB_GAMES_TITLE @"name"
#define GIANTBOMB_GAMES_RELEASE_DATE @"original_release_date"
#define GIANTBOMB_GAMES_SITE_DETAILS_URL @"site_detail_url"
#define GIANTBOMB_GAMES_PLATFORMS @"platforms"
#define GIANTBOMB_GAMES_DEVELOPERS @"developers"
#define GIANTBOMB_GAMES_PUBLISHERS @"publishers"
#define GIANTBOMB_GAMES_FRANCHISES @"franchises"
#define GIANTBOMB_GAMES_GENRES @"genres"
#define GIANTBOMB_GAMES_ARTWORK @"images"
#define GIANTBOMB_GAMES_THEMES @"themes"

// keys (paths) to values in a platform
#define GIANTBOMB_PLATFORM_ID @"id"
#define GIANTBOMB_PLATFORM_ID_API @"api_detail_url"
#define GIANTBOMB_PLATFORM_NAME @"name"
#define GIANTBOMB_PLATFORM_SITE_DETAILS_URL @"site_detail_url"
#define GIANTBOMB_PLATFORM_ABBREVIATION @"abbreviation"

// keys (paths) to values in a developer
#define GIANTBOMB_DEVELOPER_ID @"id"
#define GIANTBOMB_DEVELOPER_NAME @"name"
#define GIANTBOMB_DEVELOPER_SITE_DETAILS_URL @"site_detail_url"

// keys (paths) to values in a publisher
#define GIANTBOMB_PUBLISHER_ID @"id"
#define GIANTBOMB_PUBLISHER_NAME @"name"
#define GIANTBOMB_PUBLISHER_SITE_DETAILS_URL @"site_detail_url"

// keys (paths) to values in a franchise
#define GIANTBOMB_FRANCHISE_ID @"id"
#define GIANTBOMB_FRANCHISE_NAME @"name"
#define GIANTBOMB_FRANCHISE_SITE_DETAILS_URL @"site_detail_url"

// keys (paths) to values in a genre
#define GIANTBOMB_GENRE_ID @"id"
#define GIANTBOMB_GENRE_NAME @"name"

// keys (paths) to values in a themes
#define GIANTBOMB_THEME_ID @"id"
#define GIANTBOMB_THEME_NAME @"name"
#define GIANTBOMB_THEME_SITE_DETAILS_URL @"site_detail_url"

// keys (paths) to values in a artwork
#define GIANTBOMB_ARTWORK_TAGS @"tags"

typedef enum {
	GiantBombImageFormatIcon    = 1,        // thumbnail
	GiantBombImageFormatMedium  = 2,        // medium size
	GiantBombImageFormatScreen  = 3,        // 16:9 size
	GiantBombImageFormatSmall   = 4,        // small size
	GiantBombImageFormatSuper   = 5,        // super size
	GiantBombImageFormatThumb   = 6,        // thumb size
	GiantBombImageFormatTiny    = 7         // tiny size
} GiantBombImagesFormat;

typedef enum {
	GiantBombStatusCodeOk               = 1,       // OK
	GiantBombStatusCodeInvalidApiKey    = 100,     // Invalid API Key
	GiantBombStatusCodeObjectNotFound   = 101,     // Object Not Found
	GiantBombStatusCodeErrorURL         = 102,     // Error in URL Format
	GiantBombStatusCodeFilterError      = 104,     // Filter Error
} GiantBombStatusCode;

static NSString * const GIANTBOMB_BASE_URL = @"http://www.giantbomb.com/api";
static int const MINIMUN_STRING_SEARCH_LENGTH = 3;

@interface GiantBombFetcher : NSObject

+ (NSString *)pathForGamesByTitle:(NSString *)title andPlatform:(NSNumber *)platform andOffset:(int) offset;

+ (NSString *)pathForGamesById:(NSString *)idAPI;

+ (NSString *)pathForPlatformsByName:(NSString *)name andOffset:(int) offset;

+ (NSString *)URLforImage:(NSDictionary *)gameImages format:(GiantBombImagesFormat)format;

@end
