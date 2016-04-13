//
//  FNARoute.h
//  CTPATH-iOS
//
//  Created by fran on 13/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FNARoute : NSObject

@property (strong,nonatomic) NSDictionary * route;

-(id) initWithRoute:(NSDictionary *) route;

-(NSString *) error;
-(NSDictionary *) requestParameters;
-(NSString *) date;
-(NSString *) time;
-(NSDictionary *) plan;
-(NSArray *) itineraries;
-(NSDictionary *) itineraryAtIndex:(NSUInteger) index;
-(NSString *) durationAtIndex:(NSUInteger) index;
-(NSString *) pointsForItinerary:(NSDictionary *) itinerary;
-(UIColor *) routeColorAtIndex:(NSUInteger) index;
-(NSArray*) stepsForItinerary:(NSDictionary *) itinerary;

-(NSString *)carbonMonoxideForItinerary:(NSDictionary *) itinerary;
-(NSString *)carbonDioxideForItinerary:(NSDictionary *) itinerary;
-(NSString *)hydrocarbureForItinerary:(NSDictionary *) itinerary;
-(NSString *)nitrogenOxidesForItinerary:(NSDictionary *) itinerary;


@end

