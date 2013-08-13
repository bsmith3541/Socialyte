//
//  EventViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 7/3/13.
//
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.name.detailTextLabel.text = self.event[@"name"];
    if(!self.event[@"location"])
    {
        self.location.detailTextLabel.text = @"N/A";
    } else {
        self.location.detailTextLabel.text = self.event[@"location"];
    }
    self.startTime.detailTextLabel.text = self.event[@"start_time"];
    if(!self.event[@"end_time"]) {
        self.endTime.detailTextLabel.text = @"N/A";
    } else {
        self.endTime.detailTextLabel.text = self.event[@"end_time"];
    }
    self.friendsArray.detailTextLabel.text = @"Just me";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
