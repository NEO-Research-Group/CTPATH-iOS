//
//  FNADirectionsTableView.m
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNADirectionsTableView.h"
#import "FNADirectionsCell.h"
#import "FNAStepParser.h"
@implementation FNADirectionsTableView

-(void) awakeFromNib{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FNADirectionsCell"
                                                          bundle:nil] forCellReuseIdentifier:@"directionsCell"];
    self.tableView.dataSource = self;
    
    self.parser = [FNAStepParser new];
    
    
}

#pragma mark - DataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.directions.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FNADirectionsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"directionsCell"];
    
    
    cell.direction.text = [self.parser directionWithStep:[self.directions objectAtIndex:indexPath.row]];
    cell.directionImage.image = [self.parser imageWithStep:[self.directions objectAtIndex:indexPath.row]];
    
    return cell;
    
    
    
}

@end
