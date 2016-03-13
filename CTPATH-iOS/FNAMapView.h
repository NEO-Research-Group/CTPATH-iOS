//
//  FNAMapView.h
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <MapKit/MapKit.h>

@class FNARoute;
@interface FNAMapView : MKMapView

@property (strong,nonatomic) MKPointAnnotation * startAnnotation;
@property (strong,nonatomic)MKPointAnnotation * goalAnnotation;

@property (strong,nonatomic) NSMutableArray * itineraries;

-(void) saveLastRegion;
-(void) setDefaultRegion;
-(void) addAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates;
-(void) drawPath:(FNARoute *) plan;
@end
