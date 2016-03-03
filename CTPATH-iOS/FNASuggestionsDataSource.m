//
//  FNASuggestionsDataSource.m
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNASuggestionsDataSource.h"
#import <MapKit/MapKit.h>
@implementation FNASuggestionsDataSource

-(id) initWithData:(NSArray *) suggestions{
    
    if(self = [super init]){
        
        _suggestions = suggestions;
        
    }
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.suggestions count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
