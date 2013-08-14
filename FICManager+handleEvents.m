//
//  FICManager+handleEvents.m
//  Socialyte
//
//  Created by Hengchu Zhang on 8/14/13.
//
//

#import "FICManager+handleEvents.h"

@implementation FICManager (handleEvents)

+ (void)requestEvents
{
    // Send request to Facebook
    NSLog(@"sending request...");
    [self getEventsWithCompletionHandler:^(id result, NSError *error) {
        NSLog(@"%@", result);
        [self handleEvents:[result objectForKey:@"data"]];
    }];
}

+ (void)handleEvents:(id)arr
{
    NSLog(@"Handling events...");
    if([arr respondsToSelector:@selector(objectAtIndex:)]) {
        for (FBGraphObject *obj in arr) {
            NSDictionary *eventData = (NSDictionary *)obj;
            NSLog(@"Event Data:%@", eventData);
            // for now, only add public events to Parse db
            if ([eventData[@"privacy"] isEqualToString:@"OPEN"]) {
                PFObject *obj = [PFObject objectWithClassName:@"Event" dictionary:eventData];
                [obj saveInBackgroundWithBlock:^(BOOL completion, NSError *error){
                    if(completion) {
                        if(!error) {
                            NSLog(@"Event successfully saved to Parse");
                            
                            // if the event has lat, long data...
                            // we don't need to conditionally check for both lat and long bc
                            // if it has lat, it will also have long
                            if(eventData[@"venue"][@"latitude"]) {
                                PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[eventData[@"venue"][@"latitude"] doubleValue] longitude:[eventData[@"venue"][@"longitude"] doubleValue]];
                                [obj setObject:geoPoint forKey:@"PFGeoPoint"];
                                [obj saveInBackground];
                                NSLog(@"saved event with geopoint");
                            }
                        } else {
                            NSLog(@"There was an error uploaded the event to the Parse db");
                        }
                    }
                }];
            } else {
                NSLog(@"We're only adding public events for right now");
            }
        }
    } else {
        NSLog(@"Somehow you didn't get an array...not even any empty one...");
    }
}


@end
