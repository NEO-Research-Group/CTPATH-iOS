//
//  FNAColor.m
//  CTPATH-iOS
//
//  Created by fran on 10/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAColor.h"

@implementation FNAColor


+(UIColor *) bestPathColorWithAlpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:153.0/255.0 green:207.0/255.0 blue:28.0/255.0 alpha:alpha];
    
}

+(UIColor *) middlePathColorWithAlpha:(CGFloat) alpha{
    return [UIColor colorWithRed:128.0/255.0 green:129.0/255.0 blue:0 alpha:alpha];
}

+(UIColor *) worstPathColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:0 green:20.0/255.0 blue:0 alpha:alpha];
}

+(UIColor *) CTPathColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:228.0f/255.0f green:82.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
}

+(UIColor *) creamColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:247.0f/255.0f green:243.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
}
@end
