//
//  LoginViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/23/13.
//
//

#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import "FICManager.h"
#import <Parse/Parse.h>

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Login methods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_events"];
    
    // Login PFUser using facebook
    [FICManager openSessionWithReadPermission:permissionsArray successHandler:^{
        NSLog(@"Successfully logged in");
        [self requestEvents];
    } failureHandler:^{
        NSLog(@"Login failed");
    }];
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

-(void)requestEvents
{
    // Send request to Facebook
    NSLog(@"sending request...");
    [FICManager getEventsWithCompletionHandler:^(id result, NSError *error) {
        NSLog(@"%@", result);
        [self handleEvents:result];
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
