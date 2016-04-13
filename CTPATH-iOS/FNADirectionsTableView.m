//
//  FNADirectionsTableView.m
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNADirectionsTableView.h"
#import "FNADirectionsCell.h"
@implementation FNADirectionsTableView

-(void) awakeFromNib{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FNADirectionsCell"
                                                          bundle:nil] forCellReuseIdentifier:@"directionsCell"];
    
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.directions.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [FNADirectionsCell new];
}

@end
