//
//  FNAItinerariesView.m
//  CTPATH-iOS
//
//  Created by fran on 8/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAItinerariesTableView.h"

@implementation FNAItinerariesTableView



-(void) awakeFromNib{
    
    [self.itinerariesTableView registerNib:[UINib nibWithNibName:@"FNAItineraryCell"
                                                                      bundle:nil] forCellReuseIdentifier:@"route"];
    
    
}

@end
