//
//  EventViewController.h
//  Socialyte
//
//  Created by Brandon Smith on 7/3/13.
//
//

#import <UIKit/UIKit.h>

@interface EventViewController : UITableViewController
@property (strong, nonatomic) PFObject *event;
@property (weak, nonatomic) IBOutlet UITableViewCell *name;
@property (weak, nonatomic) IBOutlet UITableViewCell *location;
@property (weak, nonatomic) IBOutlet UITableViewCell *startTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *endTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *friendsArray;



@end
