//
//  UserDetailsViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/23/13.
//
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
        
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
                
            //NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
                
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                // Now add the data to the UI elements
                // ...
            [self.name.detailTextLabel setText:name];
            [self.gender.detailTextLabel setText:[gender capitalizedString]];
            [self.current_city.detailTextLabel setText:location];
            [self.relationship_status.detailTextLabel setText:relationship];
            [self.fb_username.detailTextLabel setText:userData[@"username"]];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
