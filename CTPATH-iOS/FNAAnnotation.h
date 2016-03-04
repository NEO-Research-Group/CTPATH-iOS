//
//  FNAAnnotation.h
//  CTPATH-iOS
//
//  Created by fran on 4/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FNAAnnotation : NSObject <MKAnnotation>

@property (copy,nonatomic) NSString * type;

-(id) initWithCoordinates:(CLLocationCoordinate2D) coordinates type:(NSString *) type;

@end
