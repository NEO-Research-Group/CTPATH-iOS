//
//  FNAMapViewController.h
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FNAMapView;

@interface FNAMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet FNAMapView *mapView;

@property (weak, nonatomic) IBOutlet UISearchBar *startSearchBar;

@property (weak, nonatomic) IBOutlet UISearchBar *goalSearchBar;

//@property (weak, nonatomic) IBOutlet UITableView *routesTableView;

@end
