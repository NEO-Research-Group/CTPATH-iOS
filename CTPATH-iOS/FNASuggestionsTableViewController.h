//
//  FNASuggestionsTableViewController.h
//  CTPATH-iOS
//
//  Created by fran on 5/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class FNASuggestionsTableViewController;
@protocol FNASuggestionsTableViewDelegate <NSObject>

-(void) suggestionsTableViewController:(FNASuggestionsTableViewController *) suggestionsTableView didSelectMapItem:(MKMapItem *) mapItem;

@end

@interface FNASuggestionsTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong,nonatomic) id <FNASuggestionsTableViewDelegate> delegate;

@property (strong,nonatomic) UISearchBar * startSearchBar;
@property (strong,nonatomic) UISearchBar * goalSearchBar;

@property (strong,nonatomic) NSArray * mapItems;

@end
