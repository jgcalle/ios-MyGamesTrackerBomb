//
//  GiantBombFetcher.m
//  MyGamesTracker
//
//  Created by MIMO on 11/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "GiantBombFetcher.h"
#import "GiantBombAPIKey.h"

@implementation GiantBombFetcher

+ (NSString *)pathForPlatformsByName:(NSString *)name andOffset:(int) offset
{
    
    NSString *fields = @"&field_list=abbreviation,api_detail_url,deck,id,image,name,release_date,site_detail_url";
    NSString *query = [NSString stringWithFormat:@"platforms/?api_key=%@&format=json",GIANTBOMB_API_KEY];
    
    NSString *queryFilter = nil;
    if (name) {
        queryFilter = [queryFilter stringByAppendingString:[NSString stringWithFormat:@"&filter=platforms:%@", name]];
        query = [query stringByAppendingString:queryFilter];
    }
    query = [query stringByAppendingString:fields];    
    query = [query stringByAppendingString:[NSString stringWithFormat:@"&offset=%d",offset]];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return query;
}


+ (NSString *)pathForGamesByTitle:(NSString *)title andPlatform:(NSNumber *)platform andOffset:(int) offset
{
    //www.giantbomb.com/api/games/?api_key=ed9e89ab05dfc5a98e6f882eb1599088be4b2590&format=json&filter=name:mario%20bros,platforms:138
    
    NSString *fields = @"&field_list=api_detail_url,deck,id,image,name,original_release_date,platforms,site_detail_url";
    NSString *query = [NSString stringWithFormat:@"games/?api_key=%@&format=json&filter=",GIANTBOMB_API_KEY];
    
    
    NSString *queryFilter = [NSString stringWithFormat:@"name:%@", title];
    if (platform) {
        queryFilter = [queryFilter stringByAppendingString:[NSString stringWithFormat:@",platforms:%d", [platform intValue]]];
    }
    
    query = [query stringByAppendingString:queryFilter];
    query = [query stringByAppendingString:fields];
    query = [query stringByAppendingString:[NSString stringWithFormat:@"&offset=%d",offset]];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return query;
}

+ (NSString *)pathForGamesById:(NSString *)idAPI
{
    
    //www.giantbomb.com/api/game/3030-20487/?api_key=ed9e89ab05dfc5a98e6f882eb1599088be4b2590&format=json

    NSString *fields = @"&field_list=    api_detail_url,deck,developers,franchises,genres,id,image,images,name,original_release_date,platforms,publishers,site_detail_url,themes";
    
    NSString *query = [NSString stringWithFormat:@"game/%@/?api_key=%@&format=json",idAPI,GIANTBOMB_API_KEY];
    query = [query stringByAppendingString:fields];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return query;
}

+ (NSString *)URLforImage:(NSDictionary *)gameImages format:(GiantBombImagesFormat)format
{
    NSString *formatString = nil;
	switch (format) {
		case GiantBombImageFormatIcon:    formatString = @"icon_url";   break;
		case GiantBombImageFormatMedium:  formatString = @"medium_url"; break;
		case GiantBombImageFormatScreen:  formatString = @"screen_url"; break;
		case GiantBombImageFormatSmall:   formatString = @"small_url";  break;
		case GiantBombImageFormatSuper:   formatString = @"super_url";  break;
		case GiantBombImageFormatThumb:   formatString = @"thumb_url";  break;
		case GiantBombImageFormatTiny:    formatString = @"tiny_url";   break;
        default:                          formatString = @"medium_url"; break;
	}
    
    return [gameImages valueForKeyPath:formatString];
}

@end
