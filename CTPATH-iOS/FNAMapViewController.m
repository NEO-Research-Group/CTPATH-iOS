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
#import "FNARestClient.h"


@interface FNAMapViewController ()

@property (strong,nonatomic) CLLocationManager  * locationManager;

@property (strong,nonatomic) FNARestClient * restclient;

@end

@implementation FNAMapViewController

-(id) init{
    
    if(self = [super init]){
        
        _mapDelegate = [[FNAMapViewDelegate alloc] init];
        _restclient = [FNARestClient sharedRestClient];
    }
    
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.mapView setDefaultRegion]; //TODO: Change in the future for user location
    
    self.title = @"CTPath";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showAndHidesearchBar:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self.mapView setDelegate:self.mapDelegate];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
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
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // Minimut time elapsed to consider longPress
        
        // Take point where user longPressed and convert it to coordinates a  
        CGPoint longPressPoint = [longPress locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinates = [self.mapView convertPoint:longPressPoint toCoordinateFromView:self.mapView];
        
        [self.mapView putAnnotationWithCoordinates:coordinates];
        
        if(self.mapView.goalAnnotation){
            
            dispatch_queue_t findPathQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(findPathQueue, ^{
                
                NSDictionary * path = [self searchPathWithStartPoint:self.mapView.startAnnotation.coordinate goalPoint:coordinates];
                
                // Changes in views must be done at main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView drawPath:path];
                });
            });
        }
    }
}

#pragma mark - Map procedures

-(IBAction)centerMapAtCoordinates:(id) sender{
    
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        
        [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
        
    }else if([sender isKindOfClass:[MKPointAnnotation class]]){
        
        [self.mapView setCenterCoordinate:((MKPointAnnotation*)sender).coordinate animated:YES];
    }
}

-(void) startGettingUserLocation{
    
    // CLLocationManager is in charge of get user's location
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];  
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[MKPinAnnotationView class]]){
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Utils

-(NSDictionary*) searchPathWithStartPoint:(CLLocationCoordinate2D) startPoint goalPoint:(CLLocationCoordinate2D) goalPoint{
    
#warning Preguntar si hay otra forma mejor de hacerlo, si cambia api modificar app
    
    NSMutableString * finalURL = [NSMutableString stringWithFormat:@"%@/plan?",@URL_API];
    
    NSString * fromPlace = [NSString stringWithFormat:@"fromPlace=%f,%f&",startPoint.latitude,startPoint.longitude];
    
    NSString * toPlace = [NSString stringWithFormat:@"toPlace=%f,%f&",goalPoint.latitude,goalPoint.longitude];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    
    NSString * time = [NSString stringWithFormat:@"time=%@&",[dateFormatter
                                                              stringFromDate:[NSDate date]]];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString * date = [NSString stringWithFormat:@"date=%@&",[dateFormatter
                                                              stringFromDate:[NSDate date]]];

    [finalURL appendString:fromPlace];
    
    [finalURL appendString:toPlace];
    
    [finalURL appendString:time];
    
    [finalURL appendString:date];
    
    [finalURL appendString:@"mode=CAR&"];
    
    [finalURL appendString:@"showIntermediateStops=false"];
    
    return [self.restclient getJSONFromURL:finalURL];
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

-(IBAction)moveToInfoViewController:(id) sender{
    
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
