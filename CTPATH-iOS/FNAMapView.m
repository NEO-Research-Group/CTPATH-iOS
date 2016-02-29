//
//  FNAMapView.m
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapView.h"

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

@end
