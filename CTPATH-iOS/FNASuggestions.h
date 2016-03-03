//
//  FNASuggestions.h
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNASuggestions : NSObject

@property (strong,nonatomic) NSMutableArray * mapItems;

-(id) initWithMapItems:(NSArray *) mapItems;

@end
