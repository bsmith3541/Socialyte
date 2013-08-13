//
//  EventsTableViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/24/13.
//
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"Hello...1");
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Event";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Hello...2");
    [super viewWillAppear:animated];

    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"Hello...3");
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Menu"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(revealMenu:)];
    
    // Get the reference to the current toolbar buttons
    NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    
    
        [toolbarButtons addObject:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuButton animated:YES];
//    UIBarButtonItem *settings = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Settings"
//                                   style:UIBarButtonItemStyleBordered
//                                   target:self
//                                   action:@selector(revealMenu:)];
    // Show menu button
    //self.navigationItem.leftBarButtonItem = menuButton;
    // Show settings button
//    self.navigationItem.rightBarButtonItem = settings;
    // Adds pan gesture to the view
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    // This method is called every time objects are loaded from Parse via the PFQuery
    [super objectsDidLoad:error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
}

- (void)objectsWillLoad {
    // This method is called before a PFQuery is fired to get more objects
    [super objectsWillLoad];
    NSLog(@"There are %d objects", self.objects.count);
    NSLog(@"The objects are %@", self.objects);
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    NSLog(@"Hello...9");
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    NSLog(@"the className is %@", self.parseClassName);
    NSLog(@"the query: %@", query);
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        NSLog(@"Well, that's no fun...");
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"start_time"];
    NSLog(@"Hola! The number of objects is %d", [self.objects count]);
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSLog(@"Hello...10");
    static NSString *CellIdentifier = @"eventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Start Time: %@", [object objectForKey:@"start_time"]];
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"hello again...1");
    return 0; // FIX: we need to figure out how to put the events in the right sections...
}

/* we'll have three sections: Today, Tomorrow, and the future */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"hello again...2");
    return 3;
}

/* depending on its place, we'll name the section */
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return @"Today";
    } else if (section == 1) {
        return @"Tomorrow";
    } else {
        return @"Coming up";
    }    
}



/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hello again...4");
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentSize.height - scrollView.contentOffset.y)/2 < (self.view.bounds.size.height)) {
        if (![self isLoading]) {
            [self loadNextPage];
        }
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
