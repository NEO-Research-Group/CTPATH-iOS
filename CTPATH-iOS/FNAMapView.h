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

-(void) setDefaultRegion;
-(void) putAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates;
@end
