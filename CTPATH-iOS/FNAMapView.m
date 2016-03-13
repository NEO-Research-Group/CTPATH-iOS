//
//  FNAMapView.m
//  CTPATH-iOS
//
//  Created by fran on 29/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapView.h"
#import "FNARoute.h"

@implementation FNAMapView


-(void) addAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates{
    
    if(self.startAnnotation){
        
        // We have already put the start annotation, so we will put the goal annotation
        [self removeAnnotation:self.goalAnnotation];
        
        self.goalAnnotation = [MKPointAnnotation new];
        
        self.goalAnnotation.coordinate = coordinates;
        
        [self addAnnotation:self.goalAnnotation];
        
    }else{
        
        // We did not put any annotation, so we will put the start annotation
        self.startAnnotation = [MKPointAnnotation new];
        
        self.startAnnotation.coordinate = coordinates;
        
        [self addAnnotation:self.startAnnotation];
    }
}

-(void) saveLastRegion{
    
    //Variables to compute a region
    
    NSNumber *latitude = [NSNumber numberWithDouble:self.region.center.latitude];
    
    NSNumber *longitude = [NSNumber numberWithDouble:self.region.center.longitude];
    
    NSNumber *latitudeDelta = [NSNumber numberWithDouble:self.region.span.latitudeDelta];
    
    NSNumber *longitudeDelta = [NSNumber numberWithDouble:self.region.span.longitudeDelta];
    
    //Save variables in a dictionary
    NSDictionary * regionDictionary = @{@"longitude" : longitude,@"latitude" : latitude,
                                        @"longitudeDelta" : longitudeDelta, @"latitudeDelta" : latitudeDelta};
    //Create persistence
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //Save dictionary
    [defaults setObject:regionDictionary forKey:@"region"];
    
    [defaults synchronize];
    
}

-(void) setDefaultRegion{
    
    // Code to show the initial region in the map
    NSDictionary * regionDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"region"];
    
    // Compute region to show at mapView
    CLLocationDegrees longitude,latitude,longitudeDelta,latitudeDelta;
    
    if(regionDictionary){
        // Load last region selected by user
        
        latitude = [[regionDictionary objectForKey:@"latitude"] doubleValue];
        longitude = [[regionDictionary objectForKey:@"longitude"] doubleValue];
        latitudeDelta = [[regionDictionary objectForKey:@"latitudeDelta"] doubleValue];
        longitudeDelta = [[regionDictionary objectForKey:@"longitudeDelta"] doubleValue];
        
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
    
    [self setRegion:region animated:YES];
    
    [self setShowsUserLocation:YES];
        
}
-(void) drawPath:(FNARoute *) route{
    
    [self removeOverlays:self.itineraries];

    self.itineraries = [NSMutableArray new];

    NSArray * itineraries = route.itineraries;
    
    for(NSDictionary * itinerary in itineraries){
    
        const char *bytes = [[route pointsForItinerary:itinerary] UTF8String];
        NSUInteger length = [[route pointsForItinerary:itinerary]
                             lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSUInteger idx = 0;
        
        NSUInteger count = length / 4;
        CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
        NSUInteger coordIdx = 0;
        
        float latitude = 0;
        float longitude = 0;
        while (idx < length) {
            char byte = 0;
            int res = 0;
            char shift = 0;
            
            do {
                byte = bytes[idx++] - 63;
                res |= (byte & 0x1F) << shift;
                shift += 5;
            } while (byte >= 0x20);
            
            float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
            latitude += deltaLat;
            
            shift = 0;
            res = 0;
            
            do {
                byte = bytes[idx++] - 0x3F;
                res |= (byte & 0x1F) << shift;
                shift += 5;
            } while (byte >= 0x20);
            
            float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
            longitude += deltaLon;
            
            float finalLat = latitude * 1E-5;
            float finalLon = longitude * 1E-5;
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
            coords[coordIdx++] = coord;
            
            if (coordIdx == count) {
                NSUInteger newCount = count + 10;
                coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
                count = newCount;
            }
        }
        
        MKPolyline * routeLine = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
        
        free(coords);
        
        [self.itineraries addObject:routeLine];
        
        [self insertOverlay:routeLine atIndex:0 level:MKOverlayLevelAboveRoads];
        
        
    }
    
}
@end
