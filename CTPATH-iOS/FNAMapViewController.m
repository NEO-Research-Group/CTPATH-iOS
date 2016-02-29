//
//  FNAMapViewController.m
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "FNAMapViewController.h"
#import "FNAAboutViewController.h"
#import "FNAMapView.h"
#import "FNAMapViewDelegate.h"
@interface FNAMapViewController ()

@property (strong,nonatomic) CLLocationManager  * locationManager;
@property (strong,nonatomic) FNAMapViewDelegate * mapDelegate;
@end

@implementation FNAMapViewController

-(id) init{
    
    if(self = [super init]){
        
        _mapDelegate = [[FNAMapViewDelegate alloc] init];
        
    }
    
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.mapView setDefaultRegion]; // Change in the future for user location
    
    [self.mapView setDelegate:self.mapDelegate];
    
    [self configureNavBarAndToolBarButtons];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self declareGestureRecognizersForView:self.mapView];
    
    [self startGettingUserLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizer

/*! This method instantiate needed user's gestures recognizer */
-(void) declareGestureRecognizersForView:(UIView *) view{
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [view addGestureRecognizer:longPressRecognizer];
}

/*! This method tells us when the user longPressed the view */
-(void) didLongPress:(UILongPressGestureRecognizer *) longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // We consider only the aproppiate state
        
        // Take point where user longPressed and convert it to coordinates at mapView
        
        CGPoint longPressPoint = [longPress locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinates = [self.mapView convertPoint:longPressPoint toCoordinateFromView:self.mapView];
        
        [self.mapView putAnnotationWithCoordinates:coordinates];
        
         //[self searchPathWithStartPoint:self.startAnnotation.coordinate goalPoint:coordinates]
       
    }
}

#pragma mark - Map procedures

-(void) centerMapAtCoordinates:(id) sender{
    
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        
        [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
        
    }else if([sender isKindOfClass:[MKPointAnnotation class]]){
        [self.mapView setCenterCoordinate:((MKPointAnnotation*)sender).coordinate animated:YES];
    }
    
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
                             
                             if(self.mapView.startAnnotation){
                                 
                                 [self.mapView removeAnnotation:self.mapView.startAnnotation];
                                 
                                 self.mapView.startAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.mapView.startAnnotation];
                                 
                             }else{
                                 
                                 self.mapView.startAnnotation = [[MKPointAnnotation alloc] init];
                                 
                                 self.mapView.startAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.mapView.startAnnotation];
                                 
                             }
                             
                            [self centerMapAtCoordinates:self.mapView.startAnnotation];
                             
                         }else{
                             
                             // Goal
                             
                             if(self.mapView.goalAnnotation){
                                 
                                 [self.mapView removeAnnotation:self.mapView.goalAnnotation];
                                 
                                 self.mapView.goalAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.mapView.goalAnnotation];
                                 
                             }else{
                                 
                                 self.mapView.goalAnnotation = [[MKPointAnnotation alloc] init];
                                 
                                 self.mapView.goalAnnotation.coordinate = coordinates;
                                 
                                 [self.mapView addAnnotation:self.mapView.goalAnnotation];
                                 
                             }
                             
                             [self centerMapAtCoordinates:self.mapView.goalAnnotation];
                             
                         }
                     }
                 }
     ];
    
    [searchBar resignFirstResponder];
    
}
@end
