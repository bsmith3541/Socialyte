//
//  MapViewController.m
//  Socialyte
//
//  Created by Brandon Smith on 6/28/13.
//
//

#import "MapViewController.h"
#import "GeoPointAnnotation.h"
#import "EventViewController.h"
#import "EventGeoPoint.h"
#import "NSObject+PropertyList.h"
#import "EventRegion.h"

@interface MapViewController ()
@property(nonatomic, weak)GeoPointAnnotation *currentGeoPoint;
@end

@implementation MapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialize Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    // Configure Location Manager
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            // orient the map around the current location
            [self orientMap:geoPoint];
            
            // place markers for each of the events near the user
            [self queryGeoPoints:geoPoint];
        } else {
            NSLog(@"there was an error obtaining your current location");
        }
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    	// Do any additional setup after loading the view.
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotationUpdated" object:nil];
}

-(void)orientMap:(PFGeoPoint *)currLoc
{
    [self.mapView setRegion:MKCoordinateRegionMake(
                    CLLocationCoordinate2DMake(currLoc.latitude, currLoc.longitude),
                    MKCoordinateSpanMake(0.01, 0.01)
                )];
}

#pragma mark - geoPoint

- (void)queryGeoPoints:(PFGeoPoint *)geoPoint
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    // plot GeoPoints for nearby events
    dispatch_queue_t findEvents = dispatch_queue_create("find events", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(findEvents, ^{
        [query whereKey:@"PFGeoPoint" nearGeoPoint:geoPoint withinMiles:10.0];
        // Limit what could be a lot of points.
        //query.limit = 10;
        // Final list of objects
        NSArray *events = [query findObjects];
        for (PFGeoPoint *point in events) {
            //EventGeoPoint *eventPoint = [EventGeoPoint createEventGeoPointFromPFGeoPoint:point];
            //CLLocationCoordinate2D center = CLLocationCoordinate2DMake(eventPoint.latitude, eventPoint.longitude);
            //eventPoint.trueFence= [MKCircle circleWithCenterCoordinate:center radius:10.0];
            //NSLog(@"There are %d event(s) near you!", [events count]);
            //NSLog(@"Event Name: %@", [eventPoint valueForKey:@"name"]);
            [self plotGeoPoint:point];
            //[self createGeofence:point];
        }
        NSLog(@"There are %d event(s) near you!", [events count]);
//        for (PFObject *object in events) {
//            NSLog(@"Event Name: %@", [object valueForKey:@"name"]);
//            [self plotGeoPoint:object];
//            [self createGeofence:object[@"PFGeoPoint"]];
//        };
    });
}

- (void)createGeofence:(PFGeoPoint *)loc
{
    
    // place geofences on each of the event locations...
    
}

- (void)plotGeoPoint:(PFGeoPoint *)event
{
    // create GeoPointAnnotation
    GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] initWithObject:(PFObject *)event];
    [self.mapView addAnnotation:annotation];
    
    // create region from GeoPoint
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(event.latitude, event.longitude);
    EventRegion *point = (EventRegion *)[[CLRegion alloc] initCircularRegionWithCenter:center radius:10.0 identifier:[[NSUUID UUID] UUIDString]];
    
    // associate region with GeoPoint
    point.event = annotation;
    
    // Start Monitoring Region
    [self.locationManager startMonitoringForRegion:point];
    
//    MKMapKit;
    //[self performSelector:@selector(mapView:viewForAnnotation:) withObject:self.mapView withObject:annotation];
    //[self.mapView.window setNeedsDisplay];
}

-(void)loadDetailView:(PFObject *)clickedPin
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    EventViewController *eventDetail = (EventViewController *)[storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    eventDetail.event = clickedPin;
    [self presentViewController:eventDetail animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
       NSLog(@"nil"); return nil;
    }
    
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        //annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        //annotationView.draggable = NO;
        annotationView.animatesDrop = YES;
        //annotationView.annotation = annotation;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    //annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    NSLog(@"I added sumthin!");
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    
//}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    GeoPointAnnotation *clickedEvent = (GeoPointAnnotation *)view.annotation;
    [self loadDetailView:clickedEvent.object];
}


#pragma mark - ECSlidingViewController
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  //
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /* 1. update currentRegion...
       2. active GPS
       3. check to see if the region contains
       4. the user's current location
       5. verify their location
     
       there's gotta be a better way to do this 
     */
    self.currentGeoPoint = region;
    NSLog(@"Firing up the GPS!");
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D currLoc =  newLocation.coordinate;
//    if([self.currentRegion containsCoordinate:currLoc]) {
//        // need to find a way to display the event title
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-in"
//                                                        message:[NSString stringWithFormat:@"Do you want to check into this event?"]
//                                                       delegate:self
//                                              cancelButtonTitle:@"No"
//                                              otherButtonTitles:@"Yes!", nil];
//         [alert show];
//    }
    NSLog(@"%f  %f ", currLoc.latitude, currLoc.longitude);
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes!"])
    {
        NSLog(@"User checked in!");
    } else {
        NSLog(@"User did not check-in");
    }
}

@end
