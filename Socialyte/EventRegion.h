//
//  EventRegion.h
//  Socialyte
//
//  Created by Brandon Smith on 8/14/13.
//
//

#import <CoreLocation/CoreLocation.h>
#import "GeoPointAnnotation.h"

@interface EventRegion : CLRegion
@property (nonatomic, strong) GeoPointAnnotation *event;
@end
