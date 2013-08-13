//
//  EventsTableViewController.h
//  Socialyte
//
//  Created by Brandon Smith on 6/24/13.
//
//

#import <Parse/Parse.h>

@interface EventsTableViewController : PFQueryTableViewController <UIScrollViewDelegate>
- (IBAction)revealMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end
