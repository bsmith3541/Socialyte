//
//  MapViewController.h
//  Socialyte
//
//  Created by Brandon Smith on 6/28/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
//    BOOL _didStartMonitoringRegion;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) NSMutableArray *geofences;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)revealMenu:(id)sender;
@end
