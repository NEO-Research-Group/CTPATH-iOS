//
//  FNAStepParser.h
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEPART @"DEPART"
#define CONTINUE @"CONTINUE"
#define CIRCLE_COUNTERCLOCKWISE @"CIRCLE_COUNTERCLOCKWISE"
#define SLIGHTLY_LEFT @"SLIGHTLY_LEFT"
#define SLIGHTLY_RIGHT @"SLIGHTLY_RIGHT"
#define LEFT @"LEFT"
#define HARD_LEFT @"HARD_LEFT"
#define RIGHT @"RIGHT"
#define HARD_RIGHT @"HARD_RIGHT"
@interface FNAStepParser : NSObject

-(NSString *) directionWithStep:(NSDictionary *) step;
-(UIImage *) imageWithStep:(NSDictionary *) step;



@end
