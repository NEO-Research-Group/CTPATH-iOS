//
//  FNAItineraryDetailView.m
//  CTPATH-iOS
//
//  Created by fran on 10/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAItineraryDetailView.h"
#import "FNAItinerariesTableView.h"
#import "FNAColor.h"
@implementation FNAItineraryDetailView


-(id) initWithRoute:(FNARoute *)route indexPath:(NSIndexPath *) indexPath delegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource{
    
    if(self = [super init]){
        _route = route;
        _indexPath = indexPath;
        self.itinerariesView.dataSource = dataSource;
        self.itinerariesView.delegate = delegate;
        
    }
    
    return self;
}

-(void) layoutSubviews{
    
    self.routeColor.backgroundColor = [self.route routeColorAtIndex:self.indexPath.row];
    
    self.routeColor.layer.cornerRadius = self.routeColor.frame.size.width/2;
    
    self.routeColor.clipsToBounds = YES;
    
    [self fillViewsWithData];
    
    
}

-(void) awakeFromNib{
    
    [self.itinerariesView registerNib:[UINib nibWithNibName:@"FNAItineraryCell"
                                                     bundle:nil] forCellReuseIdentifier:@"route"];
    
    self.pollutionView.layer.borderColor = [[FNAColor CTPathColorWithAlpha:1.0] CGColor];
    
    self.pollutionView.layer.borderWidth = 1.5f;
    
    self.pollutionView.layer.cornerRadius = 2.0f;
    
    self.pollutionView.clipsToBounds = YES;
    
    
    
    
}

-(void) fillViewsWithData{
    
    self.routeName.text = [NSString stringWithFormat:@"Ruta %li",self.indexPath.row + 1];
    
    self.startTime.text = [NSString stringWithFormat:@"%@ %@",[self.route time],[self.route date]];
    
    self.COLabel.text = [self.route carbonMonoxideForItinerary:[self.route itineraryAtIndex:self.indexPath.row]];
    
    self.CO2Label.text = [self.route carbonDioxideForItinerary:[self.route itineraryAtIndex:self.indexPath.row]];
    
    self.HCLabel.text = [self.route hydrocarbureForItinerary:[self.route itineraryAtIndex:self.indexPath.row]];
    
    self.NO2Label.text = [self.route nitrogenOxidesForItinerary:[self.route itineraryAtIndex:self.indexPath.row]];
    
    self.duration.text = [NSString stringWithFormat:@"%@ minutos",[self.route durationAtIndex:self.indexPath.row]];
    
    
}
@end
