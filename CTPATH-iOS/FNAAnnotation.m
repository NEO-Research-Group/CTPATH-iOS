//
//  FNAAnnotation.m
//  CTPATH-iOS
//
//  Created by fran on 4/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAAnnotation.h"

@implementation FNAAnnotation
@synthesize coordinate=_coordinate;

-(id) initWithCoordinates:(CLLocationCoordinate2D) coordinates type:(NSString *) type{
    
    if(self = [super init]){
        
        _coordinate = coordinates;
        _type = type;
    }
    
    return self;
}

-(NSString *) title{
    
    return self.type;
    
}

@end
