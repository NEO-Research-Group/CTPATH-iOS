//
//  FNADataSource.m
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNADataSource.h"
#import <MapKit/MapKit.h>
#import "FNAItineraryCell.h"
#import "FNARoute.h"

@implementation FNADataSource

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return tableView.tag == 1 ? @"Itinerarios devueltos:" : @"Sugerencias";
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tableView.tag == 1 ? [[self.route itineraries] count] : [self.suggestions count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1){
        
        return [self showItinerary:tableView indexPath:indexPath];
        
    }else{
        
        return [self showSuggestions:tableView indexPath:indexPath];
        
    }
    return nil;
}

#pragma mark - Cell fillers

-(FNAItineraryCell *) showItinerary:(UITableView *) tableView indexPath:(NSIndexPath *) indexPath{
    
    FNAItineraryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"route"];
    
    cell.routeLabel.text = [NSString stringWithFormat:@"Ruta %i",(indexPath.row + 1)];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ minutos",[self.route durationAtIndex:indexPath.row]];
    
    cell.routeColor.backgroundColor = [self.route routeColorAtIndex:indexPath.row];
    
    cell.routeColor.layer.cornerRadius = cell.routeColor.frame.size.height/2;
    
    [cell.routeColor clipsToBounds];

    return cell;
}

-(UITableViewCell *) showSuggestions:(UITableView*) tableView indexPath:(NSIndexPath *) indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"point"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"point"];
    }
    
    NSString * name = [[[(MKMapItem*)([self.suggestions objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"Name"];
    
    NSString * country = [[[(MKMapItem*)([self.suggestions objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"Country"];
    
    NSString * city = [[[(MKMapItem*)([self.suggestions objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"City"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@",name,city,country];
    
    return cell;
    
}

@end