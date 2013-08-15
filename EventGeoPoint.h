//
//  EventGeoPoint.h
//  Socialyte
//
//  Created by Brandon Smith on 8/14/13.
//
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface EventGeoPoint : PFGeoPoint
@property (nonatomic, weak) MKCircle *trueFence;
@property (nonatomic, strong) CLRegion *region;

+ (EventGeoPoint *)createEventGeoPointFromPFGeoPoint:(PFGeoPoint *)pf;

@end
