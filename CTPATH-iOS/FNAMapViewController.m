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
#import "FNASuggestionsDataSource.h"

@interface FNAMapViewController ()

@property (strong,nonatomic) CLLocationManager  * locationManager;

@property (strong,nonatomic) FNARestClient * restclient;

@property (strong,nonatomic) FNASuggestionsDataSource * suggestionDataSource;

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
    
    [self changeRightBarButtonItem:UIBarButtonSystemItemSearch];
    
    [self.mapView setDelegate:self.mapDelegate];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self declareGestureRecognizers];
    
    [self startGettingUserLocation];

}

#pragma mark - Utils

-(void) changeRightBarButtonItem:(UIBarButtonSystemItem) barButtonSystemItem{
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonSystemItem target:self action:@selector(showAndHidesearchBar:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
}

/*! Show searchbar when user taps searchButton and search bars are hidden and viceversa */
-(void) showAndHidesearchBar:(id) sender{
    
    if([self.startSearchBar isHidden]){
        
        self.startSearchBar.hidden = NO;
        
        [self changeRightBarButtonItem:UIBarButtonSystemItemStop];
        
    }else{
        
        self.startSearchBar.hidden = YES;
        
        [self changeRightBarButtonItem:UIBarButtonSystemItemSearch];
        
        [self showMapWithOptions:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews ];
        
        [self.startSearchBar resignFirstResponder];
        
    }
    
    if([self.goalSearchBar isHidden]){
        
        self.goalSearchBar.hidden = NO;
        
    }else{
        
        self.goalSearchBar.hidden = YES;
        
        [self.goalSearchBar resignFirstResponder];
        
    }
}

-(void) showMapWithOptions:(UIViewAnimationOptions) options{
    
    [UIView transitionFromView:self.suggestionTableView toView:self.mapView duration:0.25 options:options completion:nil];
    
}

-(void) showSuggestionsWithOptions:(UIViewAnimationOptions) options{
    
    CGRect tableFrame = self.mapView.frame;
    
    tableFrame.origin.y = self.goalSearchBar.frame.origin.y + self.goalSearchBar.frame.size.height;
    
    self.suggestionTableView = [[UITableView alloc] initWithFrame:tableFrame];
    
    [self.view addSubview:self.suggestionTableView];
    
    self.suggestionTableView.delegate = self;
    
    [UIView transitionFromView:self.mapView toView:self.suggestionTableView duration:0.25 options:options completion:nil];
    
}

-(void) findPath{
    
    dispatch_queue_t findPathQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(findPathQueue, ^{
        
        NSString * url = [self getURLForRoutingService:self.mapView.startAnnotation.coordinate goalPoint:self.mapView.goalAnnotation.coordinate];
        
        NSDictionary * path = [self.restclient getJSONFromURL:url];
        
        // Changes in views must be done at main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView drawPath:path];
        });
    });
}

-(NSString*) getURLForRoutingService:(CLLocationCoordinate2D) startPoint goalPoint:(CLLocationCoordinate2D) goalPoint{
    
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
    
    return finalURL;
}



-(IBAction) moveToInfoViewController:(id) sender{
    
    // Create info controller and push it
    
    FNAAboutViewController * infoVC = [[FNAAboutViewController alloc] init];
    
    [self.navigationController pushViewController:infoVC animated:YES];
    
}


#pragma mark - UIGestureRecognizer

/*! This method instantiate needed user's gestures recognizer */
-(void) declareGestureRecognizers{
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];

}

/*! This method tells us when the user longPressed the view */
-(void) didLongPress:(UILongPressGestureRecognizer *) longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // Minimut time elapsed to consider longPress
        
        // Take point where user longPressed and convert it to coordinates a  
        CGPoint longPressPoint = [longPress locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinates = [self.mapView convertPoint:longPressPoint
                                                   toCoordinateFromView:self.mapView];
        
        [self.mapView addAnnotationWithCoordinates:coordinates];
        
        if(self.mapView.goalAnnotation){
            
            [self findPath];
        }
    }
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[MKPinAnnotationView class]]){
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Map procedures

-(IBAction) centerMapAtCoordinates:(id) sender{
    
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

#pragma mark - SearchBar Delegate

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    static BOOL tableViewDisplayed = NO;
    
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve |UIViewAnimationOptionShowHideTransitionViews;
    
    if([searchBar.text isEqualToString:@""]){
        [self showMapWithOptions:options];
        tableViewDisplayed = NO;
    }else{
        
        if(!tableViewDisplayed){
            [self showSuggestionsWithOptions:(UIViewAnimationOptions) options];
            tableViewDisplayed = YES;
        }
    
        NSString * address = searchText;
        
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        
        request.naturalLanguageQuery = address;
        
        request.region = self.mapView.region;
        
        MKLocalSearch * searcher = [[MKLocalSearch alloc] initWithRequest:request];
        
        [searcher startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            
            if (response && response.mapItems.count > 0) {
                
                self.suggestionDataSource = [[FNASuggestionsDataSource alloc] initWithData:response.mapItems];
                
                self.suggestionTableView.dataSource = self.suggestionDataSource;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.suggestionTableView reloadData];
                });
            }
               
        }];
    }
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}
@end
