//
//  FNAMapViewController.m
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FNAAboutViewController.h"

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
    
    [self loadDefaultRegionForMapView];
    
    [self startGettingUserLocation];
    
    [self declareGestureRecognizersForMapView];
    
    [self configureNavBarAndToolBarButtons];
    
    [self configureView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIGestureRecognizer

/*! This method instantiate needed user's gestures recognizer */
-(void) declareGestureRecognizersForMapView{
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];
    
}
/*! This method tells us when the user longPressed the view */
-(void) didLongPress:(UILongPressGestureRecognizer *) longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // We consider only the aproppiate state
        
        // Take point where user longPressed and convert it to coordinates at mapView
        
        CGPoint longPressPoint = [longPress locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinates = [self.mapView convertPoint:longPressPoint toCoordinateFromView:self.mapView];
        
        [self putAnnotationWithCoordinates:coordinates];
       
    }
}

#pragma mark - Map procedures

-(void) putAnnotationWithCoordinates:(CLLocationCoordinate2D) coordinates{
    
    if(self.startPointAnnotation){
        
        // We have already put the start annotation, so we will put the goal annotation
        
        if(self.endPointAnnotation) {
            
            //Remove it if already exists
            
            [self.mapView removeAnnotation:self.endPointAnnotation];
            
        }
        self.endPointAnnotation = [[MKPointAnnotation alloc] init];
        
        [self.endPointAnnotation setCoordinate:coordinates];
        
        [self.mapView addAnnotation:self.endPointAnnotation];
        
        //Search path in background
        
        [self searchPathWithStartPoint:self.startPointAnnotation.coordinate goalPoint:coordinates];
        
    }else{
        
        // We did not put any annotation, so we will put the start annotation
        
        self.startPointAnnotation = [[MKPointAnnotation alloc] init];
        
        [self.startPointAnnotation setCoordinate:coordinates];
        
        [self.mapView addAnnotation:self.startPointAnnotation];
        
    }
}

-(void) centerMapAtCoordinates:(id) sender{
    
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        
        [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
        
    }else if([sender isKindOfClass:[MKPointAnnotation class]]){
        [self.mapView setCenterCoordinate:((MKPointAnnotation*)sender).coordinate animated:YES];
    }
    
    
}

-(void) loadDefaultRegionForMapView{
    
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

        }
        if([annotation isEqual:self.startPointAnnotation]){
            
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

#pragma mark - CoreLocation Delegate

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    #warning Incomplete method implementation.
    
    //Hacer algo cuando la posición del usuario cambie

}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[MKPinAnnotationView class]]){
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Utils

-(void) searchPathWithStartPoint:(CLLocationCoordinate2D) startPoint goalPoint:(CLLocationCoordinate2D) endPoint{
    
    
#warning Incomplete method implementation.
    //Buscar ruta, se llama cuando la segunda anotación es colocada
    
}

-(void) configureView{
    
    // Color for view's background
    
    UIColor *creamColor = [UIColor colorWithRed:247.0f/255.0f green:243.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    
    [self.view setBackgroundColor:creamColor];
    
    // Hide searchbars when app starts
    
    self.goalSearchBar.hidden = YES;
    
    self.startSearchBar.hidden = YES;
}

-(void) configureNavBarAndToolBarButtons{
    
    self.title = @"CTPath";
    
    [self.navigationController setToolbarHidden:NO];
    
    // Create buttons for navbar
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showAndHidesearchBar:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    //Create buttons for toolbar
    
    UIBarButtonItem *userLocationButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"localization"] landscapeImagePhone:[UIImage imageNamed:@"localization"] style:UIBarButtonItemStyleDone target:self action:@selector(centerMapAtCoordinates:)];
    
    UIBarButtonItem *flexButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton * infoAppButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    [infoAppButton addTarget:self action:@selector(moveToInfoViewController:) forControlEvents:UIControlEventTouchUpInside];
    [infoAppButton setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem * infoAppButtonItem = [[UIBarButtonItem alloc] initWithCustomView: infoAppButton];    
    
    self.toolbarItems = [NSArray arrayWithObjects: userLocationButtonItem,flexButtonItem,infoAppButtonItem, nil];
    
}
/*! Show searchbar when user taps searchButton and search bars are hidden and viceversa */
-(void) showAndHidesearchBar:(id) sender{
    
    if([self.startSearchBar isHidden]){
        
        self.startSearchBar.hidden = NO;
        
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(showAndHidesearchBar:)];
        
        self.navigationItem.rightBarButtonItem = searchButton;
        
    }else{
        
        self.startSearchBar.hidden = YES;
        
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showAndHidesearchBar:)];
        
        self.navigationItem.rightBarButtonItem = searchButton;
        
    }
    
    if([self.goalSearchBar isHidden]){
        
        self.goalSearchBar.hidden = NO;
        
    }else{
        
        self.goalSearchBar.hidden = YES;
        
    }
}

-(void) moveToInfoViewController:(UIBarButtonItem*) sender{
    
    // Create info controller and push it
    
    FNAAboutViewController * infoVC = [[FNAAboutViewController alloc] init];
    
    [self.navigationController pushViewController:infoVC animated:YES];
    
}
/*
#pragma mark - TableView Delegate


#pragma mark - TableView DataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"path"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"path"];
    }
    
    cell.textLabel.text = @"Hola juanra!";
    
    return cell;
    
}
*/

#pragma mark - SearchBar Delegate


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString * address = searchBar.text;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = address;
    
    request.region = self.mapView.region;

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark * pl = [placemarks objectAtIndex:0];
                    
                         CLLocationCoordinate2D coordinates = pl.location.coordinate;
                         
                         if(searchBar.tag == 1){
                             
                             // Start
                             
                             if(self.startPointAnnotation){
                                 
                                 [self.mapView removeAnnotation:self.startPointAnnotation];
                                 
                                 self.startPointAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.startPointAnnotation];
                                 
                             }else{
                                 
                                 self.startPointAnnotation = [[MKPointAnnotation alloc] init];
                                 
                                 self.startPointAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.startPointAnnotation];
                                 
                             }
                             
                            [self centerMapAtCoordinates:self.startPointAnnotation];
                             
                         }else{
                             
                             // Goal
                             
                             if(self.endPointAnnotation){
                                 
                                 [self.mapView removeAnnotation:self.endPointAnnotation];
                                 
                                 self.endPointAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.endPointAnnotation];
                                 
                             }else{
                                 
                                 self.endPointAnnotation = [[MKPointAnnotation alloc] init];
                                 
                                 self.endPointAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.endPointAnnotation];
                                 
                             }
                             
                             [self centerMapAtCoordinates:self.endPointAnnotation];
                             
                         }
                         
                         
                     }
                 }
     ];
    
    [searchBar resignFirstResponder];
    
}
@end
