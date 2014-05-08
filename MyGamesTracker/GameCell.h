//
//  GameCell.h
//  MyGamesTracker
//
//  Created by MIMO on 12/02/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellUIImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformsLabel;

@end
