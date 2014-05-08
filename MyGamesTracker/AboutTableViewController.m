//
//  AboutTableViewController.m
//  MyGamesTracker
//
//  Created by MIMO on 10/03/14.
//  Copyright (c) 2014 MIMO. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailTextLabel;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

@implementation AboutTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Properties
    self.table.tableFooterView = [UIView new];                      // Fake footer
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;  // No Cell Separator
 
    // Localized Strings
    self.emailTextLabel.text = NSLocalizedString(@"STRING_EMAIL_TEXT", nil);
    
}


// Create a email with Email Application to recipient with subject
-(BOOL) sendEmail:(NSString *)recipient withSubject:(NSString *)subject
{
    BOOL isOpenEmailClient = NO;
    NSString *withSubject = @"";
    
    if (recipient) {
        if (subject) {
            withSubject = [NSString stringWithFormat:@"?subject=%@",subject];
        }
        NSString *email = [NSString stringWithFormat:@"mailto:%@%@", recipient, withSubject];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        
        isOpenEmailClient = YES;
    }
    
    return isOpenEmailClient;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ((indexPath.section == 0) && (indexPath.row == 4)) {     // Email Cell
        
        [self sendEmail:NSLocalizedString(@"STRING_EMAIL_RECIPIENT", nil) withSubject:NSLocalizedString(@"STRING_EMAIL_SUBJECT", nil)];
    }
    
}

@end
