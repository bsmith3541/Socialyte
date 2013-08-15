//
//  EventGeoPoint.m
//  Socialyte
//
//  Created by Brandon Smith on 8/14/13.
//
//

#import "EventGeoPoint.h"
#import "NSObject+PropertyList.h"

@implementation EventGeoPoint
@synthesize trueFence = _trueFence;
@synthesize region = _region;

+ (EventGeoPoint *)createEventGeoPointFromPFGeoPoint:(PFGeoPoint *)pf
{
    EventGeoPoint *event;
    NSArray *propertyList = [pf allPropertyNames];
    for (NSString *property in propertyList) {
        [event setValue:[pf valueForKey:property] forKey:property];
    }
    return event;
}

@end
