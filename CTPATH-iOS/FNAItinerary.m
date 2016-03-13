//
//  FNAItinerary.m
//  CTPATH-iOS
//
//  Created by fran on 13/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAItinerary.h"

@implementation FNAItinerary


-(id) initWithName:(NSString *)name
          duration:(NSString *)duration
              date:(NSString *)date
              time:(NSString *)time
     carbonDioxide:(NSString *)carbonDioxide
        routeColor:(FNAColor *)routeColor{
    
    if(self = [super init]){
        _name = name;
        _duration = duration;
        _date = date;
        _time = time;
        _carbonDioxide = carbonDioxide;
        _routeColor = routeColor;
    }
    
    return self;
}

@end
