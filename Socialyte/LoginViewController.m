//
//  LoginViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/23/13.
//
//

#import "LoginViewController.h"
#import "UserDetailsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Facebook Profile";
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
        //[self performSegueWithIdentifier:@"userDetails" sender:self];
    }
}

#pragma mark - Login methods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_events"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
           // [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            //[self performSegueWithIdentifier:@"userDetails" sender:self];
        } else {
            NSLog(@"User with facebook logged in!");
            [self requestEvents];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

-(void)requestEvents
{

    FBRequest *request = [FBRequest requestForMe];
    
    
    // Send request to Facebook
    NSLog(@"sending request...");
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"userData: %@", userData);
            NSLog(@"FQL Query for Events...");
            
            // Query to fetch events the user has been invited to
            NSString *query =
            @"SELECT uid, eid, rsvp_status, start_time FROM event_member WHERE uid = me()";
//            @"SELECT uid, eid, rsvp_status, name, start_time, end_time, location, venue FROM event_member WHERE uid = me()";
            
            // Set up the query parameter
            NSDictionary *queryParam = @{ @"q": query };
            
            // Make the API request that uses FQL
            [FBRequestConnection startWithGraphPath:@"/fql"
                                         parameters:queryParam
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                                      if (error) {
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                      } else {
                                          NSLog(@"FQL Result: %@", result[@"data"]);
                                          NSLog(@"The result's class is %@", [result[@"data"] className]);
                                          [self handleEvents:result[@"data"]];
                                      }
                                  }];
            // [self performSegueWithIdentifier:@"userDetails" sender:self];
            
            // [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
}

// receives the result from the FQL query
// extracts event data and adds the event to Parse db
-(void)handleEvents:(id)arr
{
    NSLog(@"Handling events...");
    if([arr respondsToSelector:@selector(objectAtIndex:)]) {
        for (FBGraphObject *obj in arr) {
            NSLog(@"Requesting Event with ID: %@...", [obj objectForKey:@"eid"]);
            FBRequest *eventsRequest = [FBRequest requestForGraphPath:
                                        [NSString stringWithFormat:@"%@", obj[@"eid"]]];

            [eventsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSDictionary *eventData = (NSDictionary *)result;
                NSLog(@"Event Data:%@", eventData);
                // for now, only add public events to Parse db
                if ([eventData[@"privacy"] isEqualToString:@"OPEN"]) {
                    PFObject *obj = [PFObject objectWithClassName:@"Event" dictionary:eventData];
                    [obj saveInBackgroundWithBlock:^(BOOL completion, NSError *error){
                        if(completion) {
                            if(!error) {
                                NSLog(@"Event successfully saved to Parse");
                                
                                // if the event has lat, long data...
                                // we don't need to conditionally check for both lat and long bc
                                // if it has lat, it will also have long
                                if(eventData[@"venue"][@"latitude"]) {
                                    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[eventData[@"venue"][@"latitude"] doubleValue] longitude:[eventData[@"venue"][@"longitude"] doubleValue]];
                                    [obj setObject:geoPoint forKey:@"PFGeoPoint"];
                                    [obj saveInBackground];
                                    NSLog(@"saved event with geopoint");
                                }
                            } else {
                                NSLog(@"There was an error uploaded the event to the Parse db");
                            }
                        }
                    }];
                } else {
                    NSLog(@"We're only adding public events for right now");
                }
            }];
        }
    } else {
        NSLog(@"Somehow you didn't get an array...not even any empty one...");
    }
}

@end
