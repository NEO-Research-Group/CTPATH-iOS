//
//  FNAItineraryCell.m
//  CTPATH-iOS
//
//  Created by fran on 8/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAItineraryCell.h"

@implementation FNAItineraryCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated routeColor:(UIColor *)color{
    
    [super setSelected:selected animated:animated];

    self.routeColor.backgroundColor = color;
}

@end
