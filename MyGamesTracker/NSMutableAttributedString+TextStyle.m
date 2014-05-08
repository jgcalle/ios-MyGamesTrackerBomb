//
//  NSMutableAttributedString+TextStyle.m
//  MyGamesTracker
//
//  Created by MIMO on 27/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "NSMutableAttributedString+TextStyle.h"

@implementation NSMutableAttributedString (TextStyle)

+ (NSMutableAttributedString *)attributedStringwithText:(NSString *)text withStyle:(int)style
{
    UIColor *color;
    UIColor *strokeColor;
    NSNumber *stroke;
    CGFloat fontSize = 0.0;
    int paragraphAligment = NSTextAlignmentLeft;
    
    switch (style) {
            
        case CellBody:
            color = [UIColor blackColor];
            strokeColor = [UIColor grayColor];
            stroke = [NSNumber numberWithFloat:-2.0];
            fontSize = 14.0;
            break;
            
        case CellHeadline:
            color = [UIColor blackColor];
            strokeColor = [UIColor grayColor];
            stroke = @-5.0;
            fontSize = 28.0;
            break;
            
        case CellSubheadline:
            color = [UIColor grayColor];
            strokeColor = [UIColor grayColor];
            stroke = @0.0;
            fontSize = 12.0;
            break;

        case CellHeadLineCentered:
            color = [UIColor blackColor];
            strokeColor = [UIColor grayColor];
            stroke = [NSNumber numberWithFloat:-2.0];
            fontSize = 14.0;
            paragraphAligment = NSTextAlignmentCenter;
            break;
            
        case CellSubheadlineCentered:
            color = [UIColor grayColor];
            strokeColor = [UIColor grayColor];
            stroke = @0.0;
            fontSize = 12.0;
            paragraphAligment = NSTextAlignmentCenter;
            break;
            
        default:
            color = [UIColor colorWithWhite:0.23 alpha:1.0];
            strokeColor = nil;
            stroke = nil;
            fontSize = 14.0;
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    // Add paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:paragraphAligment];

    
    
    // Add Main Font Color
    // Add Font Stroke Color
    // Add Font
    [attributedString setAttributes:@{
                                      NSForegroundColorAttributeName:color,
                                      NSStrokeColorAttributeName:strokeColor,
                                      NSStrokeWidthAttributeName:stroke,
                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName:paragraphStyle
                                      }
                              range:NSMakeRange(0,[attributedString length])];
    
    return attributedString;
}

@end