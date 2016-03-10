//
//  FNAColor.h
//  CTPATH-iOS
//
//  Created by fran on 10/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNAColor : UIColor

+(UIColor *) bestPathColorWithAlpha:(CGFloat) alpha;
+(UIColor *) middlePathColorWithAlpha:(CGFloat) alpha;;
+(UIColor *) worstPathColorWithAlpha:(CGFloat) alpha;;
+(UIColor *) CTPathColorWithAlpha:(CGFloat) alpha;;
+(UIColor *) creamColorWithAlpha:(CGFloat) alpha;;

@end
