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

/*! @brief Start point of the route */
@property (strong,nonatomic) MKPointAnnotation * startPointAnnotation;

/*! @brief End point of the route  */
@property (strong,nonatomic) MKPointAnnotation * endPointAnnotation;

@end

@implementation FNAMapViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadDefaultMapView];
    
    [self startGettingUserLocation];
    
    [self declareGestureRecognizers];
    
    [self activateNavBarAndToolBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // Temporal procedure
-(void) reset:(id) sender{

    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) activateNavBarAndToolBar{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reset:)];
    
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *userLocationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"localization"] landscapeImagePhone:[UIImage imageNamed:@"localization"] style:UIBarButtonItemStyleDone target:self action:@selector(centerMapAtUserLocation)];
    
    self.toolbarItems = [NSArray arrayWithObjects: userLocationButton, nil];
    
}

-(void) centerMapAtUserLocation{
    
    [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
}

#pragma mark - UIGestureRecognizer

/*! This method instantiate needed user's gestures recognizer */
-(void) declareGestureRecognizers{
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];
    
}
/*! This method tells us when the user longPressed the view */
-(void) didLongPress:(UILongPressGestureRecognizer *) longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // We consider only the aproppiate state
        
        // Take point where user longPressed and convert it to coordinates at mapView
        
        CGPoint longPressPoint = [longPress locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinates = [self.mapView convertPoint:longPressPoint toCoordinateFromView:self.mapView];
        
       if(self.startPointAnnotation){
           
           // We have already put the start annotation, so we will put the goal annotation
           
           if(self.endPointAnnotation) {
               
               //Remove it if already exists
               
               [self.mapView removeAnnotation:self.endPointAnnotation];
               
           }
           self.endPointAnnotation = [[MKPointAnnotation alloc] init];
            
           [self.endPointAnnotation setCoordinate:coordinates];
            
           [self.mapView addAnnotation:self.endPointAnnotation];
            
        }else{
            
            // We did not put any annotation, so we will put the start annotation
            
            self.startPointAnnotation = [[MKPointAnnotation alloc] init];
            
            [self.startPointAnnotation setCoordinate:coordinates];
            
            [self.mapView addAnnotation:self.startPointAnnotation];
            
        }
    }
}

#pragma mark - Map procedures

-(void) loadDefaultMapView{
    
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
    
    [self.mapView setRegion:region animated:YES];
    
    //Show current user's location
    
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setDelegate:self];
    
}

-(void) startGettingUserLocation{
    
    //Declare and initialize CLLocationManager
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Request user to get its current location
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    
    //Accuracy of current user's location
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];  
}

#pragma mark - MapView Delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
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
            
            if(self.endPointAnnotation){
                
                pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
                
            }else{
                
                pinView.pinTintColor = [MKPinAnnotationView redPinColor];
                
            }

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

#pragma mark - CoreLocation Delegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    #warning Incomplete method implementation.
    
    //Hacer algo cuando la posición del usuario cambie

}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[MKPinAnnotationView class]]){
        
        return NO;
    }
    
    return YES;
}

@end
