//
//  SimpleTableViewController.h
//  MyGamesTracker
//
//  Created by MIMO on 20/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleTableViewControllerDelegate <NSObject>

@required
- (void)itemSelectedatRow:(NSInteger)row inSimpleTableTitle:(NSString *)title;

@end

@interface SimpleTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *oldItemSelected;
@property (assign, nonatomic) id<SimpleTableViewControllerDelegate> delegate;

@end
