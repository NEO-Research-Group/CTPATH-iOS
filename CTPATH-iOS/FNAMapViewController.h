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



@interface FNAMapViewController : UIViewController <CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet FNAMapView *mapView;

@property (weak, nonatomic) IBOutlet UISearchBar *startSearchBar;

@property (weak, nonatomic) IBOutlet UISearchBar *goalSearchBar;

@property (strong,nonatomic) FNAMapViewDelegate * mapDelegate;

@property (strong,nonatomic)  UITableView *suggestionTableView;


@end
