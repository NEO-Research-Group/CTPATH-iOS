//
//  FNAStepParser.m
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAStepParser.h"

@interface FNAStepParser ()

- (NSString *) parseRelativeDirection:(NSString *) relativeDirection;

-(NSString *) parseStreetName:(NSString *) streetName;

@end

@implementation FNAStepParser

-(NSString *) directionWithStep:(NSDictionary *)step{
    
    return [NSString stringWithFormat:@"%@ %@",[self parseRelativeDirection:[step objectForKey:@"relativeDirection"]],[self parseStreetName:[step objectForKey:@"streetName"]]];
    
}

-(UIImage *) imageWithStep:(NSDictionary *)step{
    
    return [UIImage imageNamed:[self imageForRelativeDirection:[step objectForKey:@"relativeDirection"]]];
    
}


-(NSString *) parseRelativeDirection:(NSString *)relativeDirection{
    
    NSString * parsedRelativeDirection;
    
    if([relativeDirection isEqualToString:DEPART]){
        parsedRelativeDirection = @"Sal en dirección";
    }else if([relativeDirection isEqualToString:CONTINUE]){
        parsedRelativeDirection = @"Continúa en dirección";
    }else if([relativeDirection isEqualToString:CIRCLE_COUNTERCLOCKWISE]){
        parsedRelativeDirection = @"Gira en la glorieta en dirección";
    }else if([relativeDirection isEqualToString:SLIGHTLY_LEFT]){
        parsedRelativeDirection = @"Gira levemente a la izquierda por";
    }else if([relativeDirection isEqualToString:SLIGHTLY_RIGHT]){
        parsedRelativeDirection = @"Gira levemente a la derecha por";
    }else if([relativeDirection isEqualToString:LEFT]){
        parsedRelativeDirection = @"Gira a la izquierda por";
    }else if([relativeDirection isEqualToString:RIGHT]){
        parsedRelativeDirection = @"Gira a la derecha por";
    }else{
        parsedRelativeDirection = @"";
    }
    
    return parsedRelativeDirection;
}

-(NSString *) parseStreetName:(NSString *)streetName{
    
    return [streetName capitalizedString];
}

-(NSString *) imageForRelativeDirection:(NSString *)relativeDirection{
    
    NSString * imageForRelativeDirection;
    
    if([relativeDirection isEqualToString:DEPART]){
        imageForRelativeDirection = @"ahead.png";
    }else if([relativeDirection isEqualToString:CONTINUE]){
        imageForRelativeDirection = @"ahead.png";
    }else if([relativeDirection isEqualToString:CIRCLE_COUNTERCLOCKWISE]){
        imageForRelativeDirection = @"circle.png";
    }else if([relativeDirection isEqualToString:SLIGHTLY_LEFT]){
        imageForRelativeDirection = @"soft_left.png";
    }else if([relativeDirection isEqualToString:SLIGHTLY_RIGHT]){
        imageForRelativeDirection = @"soft_right.png";
    }else if([relativeDirection isEqualToString:LEFT]){
        imageForRelativeDirection = @"left.png";
    }else if([relativeDirection isEqualToString:RIGHT]){
        imageForRelativeDirection = @"right.png";
    }else{
        imageForRelativeDirection = @"";
    }
    
    return imageForRelativeDirection;
}




@end
