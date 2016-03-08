//
//  FNASuggestionsDataSource.m
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNASuggestionsDataSource.h"
#import <MapKit/MapKit.h>
#import "FNAItineraryCell.h"
@implementation FNASuggestionsDataSource

-(id) initWithData:(NSArray *) suggestions{
    
    if(self = [super init]){
        
        _suggestions = suggestions;
        
    }
    return self;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return tableView.tag == 1 ? @"Itinerarios devueltos:" : @"Sugerencias";
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tableView.tag == 1 ? [[self itineraries] count] : [self.suggestions count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(tableView.tag == 1){
        
        return [self showItinerary:tableView indexPath:indexPath];
        
    }else{
        
        return [self showSuggestions:tableView indexPath:indexPath];
        
    }
    
    return nil;
    
}

#pragma mark - JSON parsers

-(NSDictionary *) plan{
    
    return [self.path objectForKey:@"plan"];
    
}

-(NSArray *) itineraries{
    
    return [[self plan] objectForKey:@"itineraries"];
}

#pragma mark - Cell fillers

-(FNAItineraryCell *) showItinerary:(UITableView *) tableView indexPath:(NSIndexPath *) indexPath{
    
    FNAItineraryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"route"];
    
    cell.routeLabel.text = [NSString stringWithFormat:@"Ruta %li",(indexPath.row + 1)];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%f minutos",[[[[self itineraries] objectAtIndex:indexPath.row] objectForKey:@"duration"] doubleValue]/60];
    
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
