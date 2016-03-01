//
//  FNAMapView.m
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapView.h"

@interface FNAMapView ()

@end

@implementation FNAMapView


-(void) putAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates{
    
    if(self.startAnnotation){
        
        // We have already put the start annotation, so we will put the goal annotation
        
        if(self.goalAnnotation) {
            
            //Remove it if already exists
            
            [self removeAnnotation:self.goalAnnotation];
            
        }
        self.goalAnnotation = [[MKPointAnnotation alloc] init];
        
        [self.goalAnnotation setCoordinate:coordinates];
        
        [self addAnnotation:self.goalAnnotation];
        
    }else{
        
        // We did not put any annotation, so we will put the start annotation
        
        self.startAnnotation = [[MKPointAnnotation alloc] init];
        
        [self.startAnnotation setCoordinate:coordinates];
        
        [self addAnnotation:self.startAnnotation];
    }
}

-(void) setDefaultRegion{
    
    // Code to show the initial region in the map
    
    NSDictionary * regionDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"region"];
    
    //Compute region to show at mapView
    
    CLLocationDegrees longitude,latitude,longitudeDelta,latitudeDelta;
    
    if(regionDictionary){
        
        // Load last region selected by user
        
        latitude = [(NSNumber*) [regionDictionary objectForKey:@"latitude"] doubleValue];
        
        longitude = [(NSNumber*) [regionDictionary objectForKey:@"longitude"] doubleValue];
        
        latitudeDelta = [(NSNumber*) [regionDictionary objectForKey:@"latitudeDelta"] doubleValue];
        
        longitudeDelta = [(NSNumber*) [regionDictionary objectForKey:@"longitudeDelta"] doubleValue];
        
    }else{
        
        // Load initial region
        
        latitude = 36.7206;
        
        longitude = -4.4211;
        
        latitudeDelta = 0.05;
        
        longitudeDelta = 0.05;
    }
    
    CLLocationCoordinate2D locCoordinate = CLLocationCoordinate2DMake(latitude,longitude);
    
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(latitudeDelta,longitudeDelta);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(locCoordinate, coordinateSpan);
    
    //Set the region to the mapView
    
    [self setRegion:region animated:YES];
    
    //Show current user's location
    
    [self setShowsUserLocation:YES];
    
}
-(void) drawPath:(NSDictionary *) path{
    [self removeOverlay:self.routeLine];
        NSArray * itineraries = [[path objectForKey:@"plan"] objectForKey:@"itineraries"];
    
    NSDictionary * route = [itineraries objectAtIndex:0];
    
        NSArray * steps = [[[route objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
        
        CLLocationCoordinate2D coordinates[([steps count] + 2)];
    
        coordinates[0] = CLLocationCoordinate2DMake([((NSString*)[[[[route objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"from"] objectForKey:@"lat"]) doubleValue], [((NSString*)[[[[route objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"from"] objectForKey:@"lon"]) doubleValue]);
        
        for (int i = 0; i < [steps count] ; i++) {
            CLLocationDegrees latitude = [((NSString *)[[steps objectAtIndex:i] objectForKey:@"lat"]) doubleValue];
            CLLocationDegrees longitude = [((NSString *)[[steps objectAtIndex:i] objectForKey:@"lon"]) doubleValue];
            coordinates[i+1] = CLLocationCoordinate2DMake(latitude, longitude);
        }
        
        coordinates[([steps count] + 1)] = CLLocationCoordinate2DMake([((NSString*)[[[[route objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"to"] objectForKey:@"lat"]) doubleValue], [((NSString*)[[[[route objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"to"] objectForKey:@"lon"]) doubleValue]);
        self.routeLine = [MKPolyline polylineWithCoordinates:coordinates count:([steps count] + 2)];
        
        //[self setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
        
        [self addOverlay:self.routeLine level:MKOverlayLevelAboveRoads];
}
@end
