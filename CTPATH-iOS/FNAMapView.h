//
//  FNAMapView.h
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FNAMapView : MKMapView

@property (strong,nonatomic) MKPointAnnotation * startAnnotation;
@property (strong,nonatomic)MKPointAnnotation * goalAnnotation;
@property (nonatomic, retain) MKPolyline *routeLine; //your line

@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view

@property (strong,nonatomic) NSMutableArray * itineraries;

-(void) setDefaultRegion;
-(void) addAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates;
-(void) drawPath:(NSDictionary *) path;
@end
