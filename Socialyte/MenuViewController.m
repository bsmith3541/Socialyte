//
//  MenuViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/25/13.
//
//

#import "MenuViewController.h"
#import "EventsTableViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems = _menuItems;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:@"Events", @"Map", @"About", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* identifiers don't match the names in the menu
     so, depending on the menu cell selected,
     we need to properly set the identifier */
    NSString *identifier = [self.menuItems objectAtIndex:indexPath.row];
    if([identifier isEqualToString:@"Events"]) {
        identifier = @"mainNav";
    } else if ([identifier isEqualToString:@"Map"]) {
        identifier = @"map";
    } else {
        identifier = @"About";
    }
    
    UIViewController *newTopViewController;
    if([identifier isEqualToString:@"mainNav"]) {
        // we're actually navigating to the navigation controller, but we need to set
        // its root view controller to the tests table which needs to be initialized with initWithStyle
        UINavigationController *testNavController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        testNavController = [testNavController initWithRootViewController:[[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain]];
        newTopViewController = testNavController;
    } else {
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
