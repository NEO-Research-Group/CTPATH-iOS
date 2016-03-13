//
//  FNAMapViewController.h
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define URL_API "http://mallba3.lcc.uma.es/otp/routers/default"

@class FNAMapView;
@class FNAMapViewDelegate;
@class FNAItineraryDetailView;
@class FNARoute;

@interface FNAMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UISearchBarDelegate,UIViewControllerTransitioningDelegate>

@property (strong,nonatomic) FNARoute * route;

@property (weak, nonatomic) IBOutlet FNAMapView *mapView;

@property (weak, nonatomic) IBOutlet UISearchBar *startSearchBar;

@property (weak, nonatomic) IBOutlet UISearchBar *goalSearchBar;

@property (strong,nonatomic) FNAMapViewDelegate * mapDelegate;

@property (strong,nonatomic)  UITableView *suggestionTableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *itinerariesButton;

@property (strong,nonatomic) FNAItineraryDetailView * itinerary;

- (IBAction)itinerariesAction:(id)sender;


-(IBAction) centerMapAtCoordinates:(id) sender;
@end
