//
//  FNAItinerary.h
//  CTPATH-iOS
//
//  Created by fran on 13/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FNAColor;

@interface FNAItinerary : NSObject


@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * duration;
@property (copy,nonatomic) NSString * date;
@property (copy,nonatomic) NSString * time;
@property (copy,nonatomic) NSString * carbonDioxide;
@property (copy,nonatomic) FNAColor * routeColor;


-(id) initWithName:(NSString *) name duration:(NSString *) duration date:(NSString *) date time:(NSString *) time carbonDioxide:(NSString *) carbonDioxide routeColor:(FNAColor *) routeColor;
@end
