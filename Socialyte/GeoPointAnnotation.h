//
//  GeoPointAnnotation.h
//  Socialyte
//
//  Created by Brandon Smith on 6/30/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface GeoPointAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(PFObject *)aObject;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) CLRegion *trueFence;
@property (nonatomic, strong) CLRegion *region;
@end
