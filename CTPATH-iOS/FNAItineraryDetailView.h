//
//  FNAItineraryDetailView.h
//  CTPATH-iOS
//
//  Created by fran on 10/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FNAItineraryDetailView : UIView

@property (weak, nonatomic) IBOutlet UITableView *itinerariesView;

@property (weak, nonatomic) IBOutlet UILabel *routeName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *COLabel;
@property (weak, nonatomic) IBOutlet UILabel *CO2Label;
@property (weak, nonatomic) IBOutlet UILabel *HCLabel;
@property (weak, nonatomic) IBOutlet UILabel *NO2Label;
@end
