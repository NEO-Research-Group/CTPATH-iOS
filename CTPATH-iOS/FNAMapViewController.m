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
#import "FNARestClient.h"
#import "FNADataSource.h"
#import "FNAItinerariesView.h"
#import "FNAItineraryCell.h"
#import "FNAColor.h"
#import "FNAItineraryDetailView.h"
#import "FNARoute.h"

@interface FNAMapViewController ()

@property (strong,nonatomic) FNADataSource * dataSource;
@property (nonatomic) BOOL tableViewDisplayed;
@property (strong,nonatomic) FNAItinerariesView * itineraries;

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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.title = @"CTPath";
    
    [self.mapView setDefaultRegion]; //TODO: Change in the future for user location
    [self setRightBarButtonItem:UIBarButtonSystemItemSearch];
    self.mapView.delegate = self;
    [self removeCenterButtonItem];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self declareGestureRecognizers];
    [self startGettingUserLocation];
}

#pragma mark - Utils

-(void) removeCenterButtonItem{
    NSMutableArray *toolbarButtons = [self.bottomToolbar.items mutableCopy];
    
    [toolbarButtons removeObject:self.itinerariesButton];
    [self.bottomToolbar setItems:toolbarButtons];
}

- (IBAction)removeItinerariesView:(id)sender {

    [UIView animateWithDuration:0.25 animations:^{
        
        self.itineraries.frame = CGRectMake(0, self.view.frame.size.height, self.itineraries.frame.size.width, self.itineraries.frame.size.height);
        self.itinerary.frame = CGRectMake(0, self.view.frame.size.height, self.itineraries.frame.size.width, self.itineraries.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeCenterButtonItem];
        [self.itineraries removeFromSuperview];
        [self.itinerary removeFromSuperview];
        
    }];
}

-(void) setRightBarButtonItem:(UIBarButtonSystemItem) barButtonSystemItem{
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:barButtonSystemItem
                                     target:self action:@selector(showAndHidesearchBar:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
}

/*! Show searchbar when user taps  and search bars are hidden and viceversa */
-(void) showAndHidesearchBar:(id) sender{
    
    if([self.startSearchBar isHidden]){
        
        [UIView transitionWithView:self.startSearchBar duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
        [UIView transitionWithView:self.goalSearchBar duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
        
       
        self.startSearchBar.hidden = NO;
        self.goalSearchBar.hidden = NO;
        [self setRightBarButtonItem:UIBarButtonSystemItemStop];
        
    }else{
        [UIView transitionWithView:self.startSearchBar duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
        [UIView transitionWithView:self.goalSearchBar duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
        
        self.startSearchBar.hidden = YES;
        self.goalSearchBar.hidden = YES;
        [self setRightBarButtonItem:UIBarButtonSystemItemSearch];
        
        [self showMapWithOptions:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews];
        
        [self.startSearchBar resignFirstResponder];
        [self.goalSearchBar resignFirstResponder];
    }
}

-(void) showMapWithOptions:(UIViewAnimationOptions) options{
    
    [UIView transitionFromView:self.suggestionTableView
                        toView:self.mapView duration:0.25 options:options completion:nil];
    self.tableViewDisplayed = NO;
}

-(void) showSuggestionsWithOptions:(UIViewAnimationOptions) options{
    
    CGRect tableFrame = self.mapView.frame;
    
    tableFrame.origin.y = self.goalSearchBar.frame.origin.y + self.goalSearchBar.frame.size.height;
    
    self.suggestionTableView = [[UITableView alloc] initWithFrame:tableFrame];
    
    [self.view addSubview:self.suggestionTableView];
    
    self.suggestionTableView.delegate = self;
    self.suggestionTableView.dataSource = self.dataSource;
    
    [UIView transitionFromView:self.mapView
                        toView:self.suggestionTableView
                      duration:0.25 options:options
                    completion:^(BOOL finished) {
                            self.tableViewDisplayed = YES;
                        [self.itinerary removeFromSuperview];
                        [self.itineraries removeFromSuperview];
                        }];
    
}

-(void) findPath{
    
    if(self.mapView.goalAnnotation){
        
        [self.activityView startAnimating];
        
        dispatch_queue_t findPathQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(findPathQueue, ^{
        
            NSString * url = [self getURLForRoutingService:self.mapView.startAnnotation.coordinate
                                             goalPoint:self.mapView.goalAnnotation.coordinate];
        
            self.route = [[FNARoute alloc] initWithRoute:[self.restclient getJSONFromURL:url]];
            if(!self.route){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityView stopAnimating];
                    
                    [self presentAlertViewControllerWithTitle:@"Error inesperado" message:@"Comprueba tu conexión a internet"];
                });
                
            }else if(self.route.error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.activityView stopAnimating];
                    
                    [self presentAlertViewControllerWithTitle:@"¡Lo sentimos!" message:@"No se han encontrado rutas entre estos dos puntos"];
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
-(void)presentAlertViewControllerWithTitle:(NSString *) title message:(NSString *) message{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:defaultAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}

-(void) showItinerariesTableView{
    
    // Removing views already showed
    
    [self.itineraries removeFromSuperview];
    [self.itinerary removeFromSuperview];
    [self removeCenterButtonItem];
    
    // Load itineraries tableView and initialising its properties
    
    self.itineraries = [[[NSBundle mainBundle] loadNibNamed:@"FNAItinerariesView" owner:nil options:nil] objectAtIndex:0];
    
    self.itineraries.itinerariesTableView.dataSource = self.dataSource;
    self.itineraries.itinerariesTableView.delegate = self;
    self.dataSource.route = self.route;

    [self.itineraries.itinerariesTableView registerNib:[UINib nibWithNibName:@"FNAItineraryCell"
                                                                      bundle:nil] forCellReuseIdentifier:@"route"];
    // Set frame to appear at bottom of screen
    
    self.itineraries.frame = CGRectMake(0, self.mapView.frame.size.height, self.mapView.frame.size.width, self.mapView.frame.size.height/3);
    
    [self.view addSubview:self.itineraries];
    
    // Animate to show it at properly position
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.itineraries.frame = CGRectMake(0, 2*self.mapView.frame.size.height/3, self.mapView.frame.size.width, self.mapView.frame.size.height/3);
    }];
    
    // Add new button to close this new view
    
    NSMutableArray *toolbarButtons = [self.bottomToolbar.items mutableCopy];
    [toolbarButtons insertObject:self.itinerariesButton atIndex:2];
    [self.bottomToolbar setItems:toolbarButtons];
}
-(NSString*) getURLForRoutingService:(CLLocationCoordinate2D) startPoint
                           goalPoint:(CLLocationCoordinate2D) goalPoint{
    
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
    // Remove views if exists
    [self.itineraries removeFromSuperview];
    [self.itinerary removeFromSuperview];
    
    // Create info controller and show it
    FNAAboutViewController * infoVC = [FNAAboutViewController new];
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

        CLLocationCoordinate2D coordinates = [self.mapView
                                              convertPoint:[longPress locationInView:self.mapView]toCoordinateFromView:self.mapView];
        
        [self.mapView addAnnotationWithCoordinates:coordinates];
        
        [self findPath];
    }
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
    
    self.searchBarTag = [searchBar isEqual:self.startSearchBar] ? YES: NO;
    
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCrossDissolve |UIViewAnimationOptionShowHideTransitionViews;
    
    if([searchBar.text isEqualToString:@""]){
        [self showMapWithOptions:options];
        
    }else{
        
        if(!self.tableViewDisplayed){
            [self showSuggestionsWithOptions:(UIViewAnimationOptions) options];
            
        }
    
        NSString * address = searchText;
        MKLocalSearchRequest *request = [MKLocalSearchRequest new];
        
        request.naturalLanguageQuery = address;
        request.region = self.mapView.region;
        MKLocalSearch * searcher = [[MKLocalSearch alloc] initWithRequest:request];
        
        [searcher startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            
            if (response.mapItems.count > 0) {
                
                self.dataSource.suggestions = response.mapItems;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.suggestionTableView reloadData];
                });
            }
               
        }];
    }
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self searchBar:searchBar textDidChange:searchBar.text];
}
-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
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
    
    if(newState == MKAnnotationViewDragStateEnding){
            
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:self.suggestionTableView]){
        MKMapItem * mapItem = [self.dataSource.suggestions objectAtIndex:indexPath.row];
        if(self.searchBarTag){
            self.mapView.startAnnotation = [MKPointAnnotation new];
            self.mapView.startAnnotation.coordinate = mapItem.placemark.coordinate;
            [self.mapView addAnnotation:self.mapView.startAnnotation];
            [self centerMapAtCoordinates:self.mapView.startAnnotation];
        }else{
            self.mapView.goalAnnotation = [MKPointAnnotation new];
            self.mapView.goalAnnotation.coordinate = mapItem.placemark.coordinate;
            [self.mapView addAnnotation:self.mapView.goalAnnotation];
            
            [self findPath];
            
            [self showAndHidesearchBar:nil];
        }
        
        [self showMapWithOptions:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionShowHideTransitionViews];
        
        
        
    }else{
        
        [self.itineraries removeFromSuperview];
        [self.itinerary removeFromSuperview];
        
        self.itinerary = [[[NSBundle mainBundle]
                           loadNibNamed:@"FNAItineraryDetailView" owner:nil options:nil]
                          objectAtIndex:0];
        
        self.itinerary.itinerariesView.dataSource = self.dataSource;
        self.itinerary.itinerariesView.delegate = self;
        [self.itinerary.itinerariesView registerNib:[UINib nibWithNibName:@"FNAItineraryCell"
                                                                          bundle:nil] forCellReuseIdentifier:@"route"];
     
        self.itinerary.frame = CGRectMake(0, self.mapView.frame.size.height, self.mapView.frame.size.width, 2*self.mapView.frame.size.height/3);
        
        self.itinerary.routeName.text = [NSString stringWithFormat:@"Ruta %li",indexPath.row + 1];
        
        self.itinerary.startTime.text = [NSString stringWithFormat:@"%@ %@",[self.route time],[self.route date]];
        
        self.itinerary.COLabel.text = [self.route carbonMonoxideForItinerary:[self.route itineraryAtIndex:indexPath.row]];
        self.itinerary.CO2Label.text = [self.route carbonDioxideForItinerary:[self.route itineraryAtIndex:indexPath.row]];
        self.itinerary.HCLabel.text = [self.route hydrocarbureForItinerary:[self.route itineraryAtIndex:indexPath.row]];
        self.itinerary.NO2Label.text = [self.route nitrogenOxidesForItinerary:[self.route itineraryAtIndex:indexPath.row]];
        
        self.itinerary.duration.text = [[tableView cellForRowAtIndexPath:indexPath] timeLabel].text;
        [self.view addSubview:self.itinerary];
        
        self.itinerary.frame = self.itineraries.frame;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.itinerary.frame = CGRectMake(0, self.mapView.frame.size.height/3, self.mapView.frame.size.width, 2*self.mapView.frame.size.height/3);
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIScreen mainScreen] bounds].size.height >= 568)
    {
        
        return 40;
    }
    else
    {
        return 25;
    }
}

@end
