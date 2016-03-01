//
//  FNARestClient.h
//  CTPATH-iOS
//
//  Created by fran on 1/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNARestClient : NSObject


/*! Secure singleton in parallel environments */
+(instancetype) sharedRestClient;


-(NSDictionary *) getPathPlanningWithFromPlace:(NSArray *) fromPlace
                                    toPlace:(NSArray *) toPlace
                                   timeAndDate:(NSDate *)timeAndDate
                                          mode:(NSString *) mode
                                          type:(NSString *) type
                               maxWalkDistance:(NSNumber *) maxWalkDistance
                                      arriveBy:(BOOL) arriveBy
                                    wheelChair:(BOOL) wheelChair
                         showIntermediateStops:(BOOL) showIntermediateStops;

-(NSDictionary *) getJSONFromURL:(NSString *) url;

@end
