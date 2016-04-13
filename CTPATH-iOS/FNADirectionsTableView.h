//
//  FNADirectionsTableView.h
//  CTPATH-iOS
//
//  Created by fran on 13/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNADirectionsTableView : UIView <UITableViewDataSource>

@property (strong,nonatomic) NSArray * directions;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
