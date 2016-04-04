//
//  FNADataSource.h
//  CTPATH-iOS
//
//  Created by fran on 3/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FNARoute;

@interface FNADataSource : NSObject <UITableViewDataSource>

@property (strong,nonatomic) NSArray * suggestions;
@property (strong,nonatomic) FNARoute * route;

-(MKMapItem *) mapItemAtIndex:(NSInteger) index;


@end
