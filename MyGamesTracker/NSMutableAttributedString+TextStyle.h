//
//  NSMutableAttributedString+TextStyle.h
//  MyGamesTracker
//
//  Created by MIMO on 27/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	CellBody                = 1,        // body
	CellHeadline            = 2,        // headline
	CellSubheadline         = 3,        // subheadline
    CellHeadLineCentered    = 4,        // headline centered
    CellSubheadlineCentered = 5         // subheadline centered
} CellTextStyles;

@interface NSMutableAttributedString (TextStyle)

+ (NSMutableAttributedString *)attributedStringwithText:(NSString *)text withStyle:(int)style;

@end
