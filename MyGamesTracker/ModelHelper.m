//
//  ModelHelper.m
//  MyGamesTracker
//
//  Created by MIMO on 28/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "ModelHelper.h"
#import "GiantBombFetcher.h"

NSString *const NSGamesTrackerErrorDomain = @"es.mimo.jgcalle.mygamestracker";
// NSCocoaErrorDomain
// NSURLErrorDomain & CFNetworkErrors

@implementation ModelHelper

+ (void)displayAlertError:(NSError *)anError
{
    if (anError) {

        NSString *errorMsg;
        
        if ([[anError domain] isEqualToString:NSURLErrorDomain]) {                              // Errors in NSURL domain
            switch ([anError code]) {
                case NSURLErrorCannotFindHost:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_NSURL_HOST", nil);
                    break;
                case NSURLErrorCannotConnectToHost:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_NSURL_CONNECT", nil);
                    break;
                case NSURLErrorNotConnectedToInternet:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_NSURL_INTERNET", nil);
                    break;
                default:
                    errorMsg = [anError localizedDescription];
                    break;
            }
        
        } else if ([[anError domain] isEqualToString:NSGamesTrackerErrorDomain]) {             // Errors in GiantBomb domain
            switch ([anError code]) {
                case GiantBombStatusCodeInvalidApiKey:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_GIANTBOMB_API_INVALID", nil);
                    break;
                case GiantBombStatusCodeObjectNotFound:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_GIANTBOMB_API_NOT_FOUND", nil);
                    break;
                case GiantBombStatusCodeErrorURL:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_GIANTBOMB_API_URL", nil);
                    break;
                case GiantBombStatusCodeFilterError:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_GIANTBOMB_API_FILTER", nil);
                    break;
                default:
                    errorMsg = NSLocalizedString(@"STRING_ERROR_GIANTBOMB_API_ERROR", nil);
                    break;
            }
        } else {
            errorMsg = [anError localizedDescription];
        }
        
        // Show error in alertView
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STRING_HEADER_ERROR_ALERTVIEW",nil)
                                    message:errorMsg
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"STRING_CANCEL", nil)
                          otherButtonTitles:nil, nil] show];

        // Show error in console
        NSLog(@"Error (code %li), %@", (long)[anError code], [anError userInfo]);
        
    }
    
}

@end

