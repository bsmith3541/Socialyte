//
//  UserDetailsViewController.h
//  Socialyte
//
//  Created by Brandon Smith on 6/23/13.
//
//

#import <UIKit/UIKit.h>

@interface UserDetailsViewController : UITableViewController

// UITableView header view properties
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *headerNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *headerImageView;

// UITableView row data properties
@property (nonatomic, strong) NSArray *rowTitleArray;
@property (nonatomic, strong) NSMutableArray *rowDataArray;
@property (weak, nonatomic) IBOutlet UITableViewCell *name;
@property (nonatomic, strong) NSMutableData *imageData;
@property (weak, nonatomic) IBOutlet UITableViewCell *gender;
@property (weak, nonatomic) IBOutlet UITableViewCell *current_city;
@property (weak, nonatomic) IBOutlet UITableViewCell *relationship_status;
@property (weak, nonatomic) IBOutlet UITableViewCell *fb_username;


// UINavigationBar button touch handler
- (void)logoutButtonTouchHandler:(id)sender;

@end
