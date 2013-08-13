//
//  GeoPointAnnotation.m
//  Socialyte
//
//  Created by Brandon Smith on 6/30/13.
//
//

#import "GeoPointAnnotation.h"


@interface GeoPointAnnotation()

@end

@implementation GeoPointAnnotation


#pragma mark - Initialization

- (id)initWithObject:(PFObject *)aObject {
    self = [super init];
    if (self) {
        _object = aObject;
        _title = aObject[@"name"];
        _subtitle = aObject[@"start_time"];
        PFGeoPoint *geoPoint = self.object[@"PFGeoPoint"];
        [self setGeoPoint:geoPoint];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        MKCircle *fence = [MKCircle circleWithCenterCoordinate:center radius:10.0];
        self.trueFence = fence;
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
    [self.object setObject:geoPoint forKey:@"PFGeoPoint"];
    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotationUpdated" object:self.object];
        }
    }];
}

#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 3;
    }
    
//    _title = [dateFormatter stringFromDate:self.object.updatedAt];
//    _subtitle = [NSString stringWithFormat:@"%@, %@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
}

@end
