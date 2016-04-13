//
//  FNAMapViewController.m
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "FNAMapViewController.h"
#import "FNAMapView.h"
#import "FNARestClient.h"
#import "FNADataSource.h"
#import "FNAItinerariesTableView.h"
#import "FNAItineraryCell.h"
#import "FNAColor.h"
#import "FNAItineraryDetailView.h"
#import "FNARoute.h"
#import "FNADirectionsTableView.h"


@interface FNAMapViewController ()

@property (strong,nonatomic) FNADataSource * dataSource;
@property (nonatomic) BOOL tableViewDisplayed; // Must be implemented by a protocol or notification
@property (strong,nonatomic) FNAItinerariesTableView * itineraries;

/*!@brief YES for editing start point, NO for editing goal point */
@property (nonatomic) BOOL searchBarTag;
@end

@implementation FNAMapViewController

-(id) init{
    
    if(self = [super init]){
        
        _restclient = [FNARestClient sharedRestClient];
        self.dataSource = [FNADataSource new];
    }
    
    return self;
}
# pragma mark - Lifecycle

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"CTPath";
    
    [self.mapView setDefaultRegion]; //TODO: Change in the future for user location
    self.mapView.delegate = self;
    
    
    self.directionsButton.image = nil;
    self.directionsButton.enabled = NO;
    
    [self setRightBarButtonItem];
    [self setLeftBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suggestionsViewWillAppear:) name:SUGGESTIONS_APPEAR_NOTIFICATION_NAME object:nil];
    

}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self declareGestureRecognizers];
    [self startGettingUserLocation];
}

#pragma mark - Selectors

-(void) showSuggestions{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SUGGESTIONS_APPEAR_NOTIFICATION_NAME object:nil];
    
    
    [self removeSubviewsFromSuperview];
    
    FNASuggestionsTableViewController * suggestionsTVC =[[FNASuggestionsTableViewController alloc] init];
    
    suggestionsTVC.delegate = self;
    
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:suggestionsTVC] animated:YES completion:nil];
    
}

- (IBAction)showDirections:(id)sender {
    
  
    
}

-(void) openOptions{
    
    
}

- (IBAction)removeItinerariesView:(id)sender {
    
    self.directionsButton.image = nil;
    self.directionsButton.enabled = NO;
    
    self.itinerariesButton.title = @"Mostrar";
    self.itinerariesButton.action = @selector(showItinerariesTableView);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.itineraries.frame = CGRectMake(0, self.view.frame.size.height, self.itineraries.frame.size.width, self.itineraries.frame.size.height);
        self.itinerary.frame = CGRectMake(0, self.view.frame.size.height, self.itineraries.frame.size.width, self.itineraries.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeSubviewsFromSuperview];
        
        
    }];
}

#pragma mark - Utils


-(void) setRightBarButtonItem{
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                     target:self action:@selector(showSuggestions)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
}

-(void) setLeftBarButtonItem{
    
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openOptions)];
    self.navigationItem.leftBarButtonItem = optionsButton;
    
}



// SUGGESTIONS_APPEAR_NOTIFICATION
-(void) suggestionsViewWillAppear:(NSNotification *) notification{
    
    if(self.dataSource.route){
        self.itinerariesButton.title = @"Mostrar";
        self.itinerariesButton.action = @selector(showItinerariesTableView);
    }else{
        self.itinerariesButton.title = @"";
        self.itinerariesButton.action = @selector(removeItinerariesView:);
    }
    
}


-(void)presentAlertViewControllerWithTitle:(NSString *) title message:(NSString *) message{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:defaultAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}

-(void) showItinerariesTableView{
    
    // Removing views already showed
    
    [self removeSubviewsFromSuperview];
    
    
    // Load itineraries tableView and initializing its properties
    
    self.itineraries = [[[NSBundle mainBundle] loadNibNamed:@"FNAItinerariesTableView" owner:nil options:nil] objectAtIndex:0];
    
    self.itineraries.itinerariesTableView.dataSource = self.dataSource;
    self.itineraries.itinerariesTableView.delegate = self;
    self.dataSource.route = self.route;

    
    // Set frame to appear at bottom of screen
    
    self.itineraries.frame = CGRectMake(0, self.mapView.frame.size.height, self.mapView.frame.size.width, self.mapView.frame.size.height/3);
    
    [self.view addSubview:self.itineraries];
    
    // Animate to show it at properly position
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.itineraries.frame = CGRectMake(0, 2*self.mapView.frame.size.height/3, self.mapView.frame.size.width, self.mapView.frame.size.height/3);
    }];
    
    // Add new button to close this new view
    
    self.itinerariesButton.enabled = YES;
    self.itinerariesButton.title = @"Ocultar";
    self.itinerariesButton.action = @selector(removeItinerariesView:);
}
-(NSString*) getURLForRoutingService:(CLLocationCoordinate2D) startPoint
                           goalPoint:(CLLocationCoordinate2D) goalPoint{
    
#warning Preguntar si hay otra forma mejor de hacerlo, si cambia api modificar app
    
    NSMutableString * finalURL = [NSMutableString stringWithFormat:@"%@/plan?",URL_API];
    
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

-(void) removeSubviewsFromSuperview{
    
    [self.itineraries removeFromSuperview];
    [self.itinerary removeFromSuperview];
    
}


#pragma mark - UIGestureRecognizer

/*! This method instantiate needed user's gestures recognizer */
-(void) declareGestureRecognizers{
    
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    
    [self.mapView addGestureRecognizer:longPressRecognizer];
}

/*! This method is called when the user longPressed the view */
-(void) didLongPress:(UILongPressGestureRecognizer *) longPress{
    
    if(longPress.state == UIGestureRecognizerStateBegan){ // Minimum elapsed time to consider longPress

        CLLocationCoordinate2D coordinates = [self.mapView
                                              convertPoint:[longPress locationInView:self.mapView]toCoordinateFromView:self.mapView];
        
        [self.mapView addAnnotationWithCoordinates:coordinates];
        
        [self findPath];
    }
}

#pragma mark - Map procedures

-(IBAction) centerMapAtCoordinates:(id) sender{
    
    if([sender isKindOfClass:[UIBarButtonItem class]]){ // User location button pressed
        
        [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
        
    }else if([sender isKindOfClass:[MKPointAnnotation class]]){ // An annotation has been put at map
        
        [self.mapView setCenterCoordinate:((MKPointAnnotation*)sender).coordinate animated:YES];
    }
}



-(void) startGettingUserLocation{
    
    // CLLocationManager is in charge of getting user's location
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];  
}

-(void) findPath{
    
    if(self.mapView.goalAnnotation){ // Modify with notification
        
        [self.activityView startAnimating];
        
        dispatch_queue_t findPathQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(findPathQueue, ^{
            
            NSString * url = [self getURLForRoutingService:self.mapView.startAnnotation.coordinate
                                                 goalPoint:self.mapView.goalAnnotation.coordinate];
            
            self.route = [[FNARoute alloc] initWithRoute:[self.restclient getJSONFromURL:url]];
            if(self.route.error){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityView stopAnimating];
                    
                    [self presentAlertViewControllerWithTitle:@"¡Lo sentimos!" message:@"No se han encontrado rutas entre estos dos puntos"];
                });
                
            }else if(!self.route){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityView stopAnimating];
                    
                    
                    [self presentAlertViewControllerWithTitle:@"Error inesperado" message:@"Comprueba tu conexión a internet"];
                });
                
            }else{
                // Changes in views must be done at main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mapView drawPath:self.route];
                    [self.activityView stopAnimating];
                    [self showItinerariesTableView];
                });
            }
            
        });
    }
}

#pragma mark - MapView Delegate

-(MKAnnotationView *)mapView:(FNAMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // We dont change user's location annotation
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
        
    }else{
        
        // Find annotation to reuse it
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"endAnnotationView"];
        
        if(pinView){
            
            pinView.annotation = annotation;
        }else{
            
            pinView = [[MKPinAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:@"endAnnotationView"];
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

-(void) mapView:(FNAMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    
    if(newState == MKAnnotationViewDragStateEnding){ // put down annotation
            
            [self findPath];
    }
    
}

-(void) mapView:(FNAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //When region changes, we saves this new region to load it next time user opens the app
    [mapView saveLastRegion];
}

- (MKOverlayRenderer *)mapView:(FNAMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    UIColor * overlayColor;
    
    if([overlay isEqual:[mapView.itineraries objectAtIndex:0]]){
        overlayColor = [FNAColor bestPathColorWithAlpha:1.0];
    }else if([overlay isEqual:[mapView.itineraries objectAtIndex:1]]){
        overlayColor = [FNAColor middlePathColorWithAlpha:1.0];
    }else{
        overlayColor = [FNAColor worstPathColorWithAlpha:1.0];
    }
    
    renderer.strokeColor = overlayColor;
    renderer.lineWidth = 5.0;

    return renderer;
}

#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIScreen mainScreen] bounds].size.height >= 568){
        
        return 40;
        
    }else{
        return 25;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:self.itineraries.itinerariesTableView]){
        
        // Selected cell is from FNAItinerariesView, so we create the FNAItineraryDetailView
        
        [self removeSubviewsFromSuperview]; // Removing subviews already presented
        
        // Add directionsButton to toolbar
        self.directionsButton.image = [UIImage imageNamed:@"arrows.png"];
        self.directionsButton.enabled = YES;
        
        self.itinerary = [[[[NSBundle mainBundle]
                            loadNibNamed:@"FNAItineraryDetailView" owner:nil options:nil]
                           objectAtIndex:0]
                          initWithRoute:self.route indexPath:indexPath delegate:self
                          dataSource:self.dataSource];
        
        // FNAItineraryDetailView appears at same position than FNAItinerariesView
        
        self.itinerary.frame = self.itineraries.frame;
        
        [self.view addSubview:self.itinerary];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.itinerary.frame = CGRectMake(0, self.mapView.frame.size.height/3, self.mapView.frame.size.width, 2*self.mapView.frame.size.height/3);
        }];
        
    }else{
        
        // Selected cell is from FNAItineraryDetailView so, simply update models and update subviews
        
        self.itinerary.route = self.route; // Update model
        self.itinerary.indexPath = indexPath; // Update model
        [self.itinerary layoutSubviews]; // Update subviews
        
        [self.view addSubview:self.itinerary];
        
        // Keep routeColor for selected cell style
        
        FNAItineraryCell * cell = (FNAItineraryCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.routeColor.backgroundColor = [self.route routeColorAtIndex:indexPath.row];
    }

}

// Functions to keep backgroundColor of routeColor

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![tableView isEqual:self.suggestionTableView]){
        FNAItineraryCell * cell = (FNAItineraryCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.routeColor.backgroundColor = [self.route routeColorAtIndex:indexPath.row];
    }
    
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![tableView isEqual:self.suggestionTableView]){
        FNAItineraryCell * cell = (FNAItineraryCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.routeColor.backgroundColor = [self.route routeColorAtIndex:indexPath.row];
    }

}

#pragma mark - FNASuggestionsTableViewDelegate

-(void) suggestionsTableViewController:(FNASuggestionsTableViewController *)suggestionsTableView didSelectMapItem:(MKMapItem *)mapItem withSearchBar:(NSString *)searchBar{
    
    
    // Selected cell is from suggestions tableView
    
    if([searchBar isEqualToString:START_SEARCH_BAR]){
        
        [self.mapView removeAnnotation:self.mapView.startAnnotation];
        self.mapView.startAnnotation = [MKPointAnnotation new];
        self.mapView.startAnnotation.coordinate = mapItem.placemark.coordinate;
        [self.mapView addAnnotation:self.mapView.startAnnotation];
        [self centerMapAtCoordinates:self.mapView.startAnnotation];
        
    }else{
        
        [self.mapView removeAnnotation:self.mapView.goalAnnotation];
        self.mapView.goalAnnotation = [MKPointAnnotation new];
        self.mapView.goalAnnotation.coordinate = mapItem.placemark.coordinate;
        [self.mapView addAnnotation:self.mapView.goalAnnotation];
        [self findPath];
        
    }
    
}

@end