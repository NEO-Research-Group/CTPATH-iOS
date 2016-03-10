//
//  FNAItineraryCell.h
//  CTPATH-iOS
//
//  Created by fran on 8/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNAItineraryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *routeColor;

-(void) setSelected:(BOOL)selected animated:(BOOL)animated routeColor:(UIColor*) color;

@end
