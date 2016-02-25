//
//  FNAMapViewController.m
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface FNAMapViewController ()

@property (strong,nonatomic) CLLocationManager  * locationManager;

@end

@implementation FNAMapViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadDefaultMapView];
    
    [self startGettingUserLocation];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    
    [self.mapView addGestureRecognizer:tap];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mapView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didTap:(UITapGestureRecognizer *) tap{
    
    if(tap.state == UIGestureRecognizerStateRecognized){
        
        NSLog(@"Hola");
        
    }
    
}

#pragma mark - Map procedures

-(void) loadDefaultMapView{
    
    // Code to show the initial region in the map
    
    NSDictionary * regionDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"region"];
    
    //Compute region
    
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
    
    [self.mapView setRegion:region animated:YES];
    
    //Show current user's location
    
    [self.mapView setShowsUserLocation:YES];
    
    
}

-(void) startGettingUserLocation{
    
    //Declare and initialize CLLocationManager
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    //Request user to get its current location
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    
    //Accuracy of current user's location
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];  
}

#pragma mark - MapView Delegate



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

#pragma mark - CoreLocation Delegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"%@",[locations objectAtIndex:0]);
    
}

@end
