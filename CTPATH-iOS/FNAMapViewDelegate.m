//
//  FNAMapViewDelegate.m
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapViewDelegate.h"
#import "FNAMapView.h"
@implementation FNAMapViewDelegate 

-(MKAnnotationView *)mapView:(FNAMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // We dont change user's location annotation
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
        
    }else{
        
        // Find annotation to reuse it
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"endAnnotationView"];
        
        if(pinView){
            
            // If we find a reusable annotation
            
            pinView.annotation = annotation;
            
        }else{
            
            // If not we will create one
            
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"endAnnotationView"];
            
            [pinView setAnimatesDrop:YES];
            
            [pinView setDraggable:YES];
            
        }
        if([annotation isEqual:mapView.startAnnotation]){
            
            pinView.pinTintColor = [MKPinAnnotationView redPinColor];
            
        }else{
            
            pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
            
        }
        return pinView;
    }
    return nil;
}

-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    
#warning Incomplete method implementation.
    
    // Cuando se actualice la anotación, solicitar nuevas rutas
    if(newState == MKAnnotationViewDragStateEnding){
        
    }
    
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //When region changes, we saves this new region to load it next time user opens the app
    
    //Variables to compute a region
    
    NSNumber *latitude = [NSNumber numberWithDouble:mapView.region.center.latitude];
    
    NSNumber *longitude = [NSNumber numberWithDouble:mapView.region.center.longitude];
    
    NSNumber *latitudeDelta = [NSNumber numberWithDouble:mapView.region.span.latitudeDelta];
    
    NSNumber *longitudeDelta = [NSNumber numberWithDouble:mapView.region.span.longitudeDelta];
    
    //Save variables in a dictionary
    
    NSDictionary * regionDictionary = @{@"longitude" : longitude,@"latitude" : latitude,
                                        @"longitudeDelta" : longitudeDelta, @"latitudeDelta" : latitudeDelta};
    //Create persistence
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //Save dictionary
    
    [defaults setObject:regionDictionary forKey:@"region"];
    
    [defaults synchronize];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

@end
