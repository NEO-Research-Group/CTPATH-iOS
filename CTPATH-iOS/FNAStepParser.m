//
//  FNAStepParser.m
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAStepParser.h"

@interface FNAStepParser ()

- (NSString *) parseRelativeDirectionWithStep:(NSDictionary *) step;

-(NSString *) parseStreetName:(NSString *) streetName;

@end

@implementation FNAStepParser

-(NSString *) directionWithStep:(NSDictionary *)step{
    
    return [NSString stringWithFormat:@"%@ %@",[self parseRelativeDirectionWithStep:step],[self parseStreetName:[step objectForKey:@"streetName"]]];
    
}

-(UIImage *) imageWithStep:(NSDictionary *)step{
    
    return [UIImage imageNamed:[self imageForRelativeDirection:[step objectForKey:@"relativeDirection"]]];
    
}


-(NSString *) parseRelativeDirectionWithStep:(NSDictionary *) step{
    
    NSString * parsedRelativeDirection;
    NSString * relativeDirection = [step objectForKey:@"relativeDirection"];
    
    if([relativeDirection isEqualToString:DEPART]){
        parsedRelativeDirection = @"Sal en dirección:";
    }else if([relativeDirection isEqualToString:CONTINUE]){
        parsedRelativeDirection = @"Continúa en dirección:";
    }else if([relativeDirection isEqualToString:CIRCLE_COUNTERCLOCKWISE]){
        parsedRelativeDirection = [NSString stringWithFormat:@"Tome la rotonda y salga por la %@ salida:",[self ordinalForExit:[step objectForKey:@"exit"]]];
    }else if([relativeDirection isEqualToString:SLIGHTLY_LEFT]){
        parsedRelativeDirection = @"Gira levemente a la izquierda:";
    }else if([relativeDirection isEqualToString:SLIGHTLY_RIGHT]){
        parsedRelativeDirection = @"Gira levemente a la derecha:";
    }else if([relativeDirection isEqualToString:LEFT]){
        parsedRelativeDirection = @"Gira a la izquierda:";
    }else if([relativeDirection isEqualToString:RIGHT] || [relativeDirection isEqualToString:HARD_RIGHT]){
        parsedRelativeDirection = @"Gira a la derecha:";
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
        imageForRelativeDirection = @"ahead.png";
    }
    
    return imageForRelativeDirection;
}

-(NSString *) ordinalForExit:(NSString *) exit{
    NSString * ordinal;
    
    if ([exit isEqualToString:@"1"]) {
        ordinal = @"primera";
    }else if([exit isEqualToString:@"2"]){
        ordinal = @"segunda";
    }else if([exit isEqualToString:@"3"]){
        ordinal = @"tercera";
    }else if([exit isEqualToString:@"4"]){
        ordinal = @"cuarta";
    }else if([exit isEqualToString:@"5"]){
        ordinal = @"quinta";
    }else if([exit isEqualToString:@"6"]){
        ordinal = @"sexta";
    }else if([exit isEqualToString:@"7"]){
        ordinal = @"septima";
    }else if([exit isEqualToString:@"8"]){
        ordinal = @"octava";
    }
    
    return ordinal;
    
}


@end
