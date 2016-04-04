//
//  FNAItineraryDetailView.h
//  CTPATH-iOS
//
//  Created by fran on 10/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNARoute.h"
@interface FNAItineraryDetailView : UIView

@property (strong,nonatomic) FNARoute * route;
@property (strong,nonatomic) NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UITableView *itinerariesView;
@property (weak, nonatomic) IBOutlet UILabel *routeName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *COLabel;
@property (weak, nonatomic) IBOutlet UILabel *CO2Label;
@property (weak, nonatomic) IBOutlet UILabel *HCLabel;
@property (weak, nonatomic) IBOutlet UILabel *NO2Label;
@property (weak, nonatomic) IBOutlet UIView *pollutionView;
@property (weak, nonatomic) IBOutlet UIView *routeColor;

-(id) initWithRoute:(FNARoute *) route indexPath:(NSIndexPath *) indexPath;

@end
