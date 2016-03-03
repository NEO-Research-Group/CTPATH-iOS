//
//  FNASuggestions.m
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNASuggestions.h"

@implementation FNASuggestions

-(id) initWithMapItems:(NSArray *) mapItems{
    
    if(self = [super init]){
        
        _mapItems = [NSMutableArray arrayWithArray:mapItems];
    }
    return self;
}

@end
