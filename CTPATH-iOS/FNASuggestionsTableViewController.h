//
//  FNASuggestionsTableViewController.h
//  CTPATH-iOS
//
//  Created by fran on 5/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define START_SEARCH_BAR @"START"
#define GOAL_SEARCH_BAR @"GOAL"


@class FNASuggestionsTableViewController;
@protocol FNASuggestionsTableViewDelegate <NSObject>

-(void) suggestionsTableViewController:(FNASuggestionsTableViewController *) suggestionsTableView didSelectMapItem:(MKMapItem *) mapItem withSearchBar:(NSString *) searchBar;

@end

@interface FNASuggestionsTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong,nonatomic) id <FNASuggestionsTableViewDelegate> delegate;

@property (strong,nonatomic) UISearchBar * startSearchBar;
@property (strong,nonatomic) UISearchBar * goalSearchBar;

@property (copy,nonatomic) NSString * active_searchBar;

@property (strong,nonatomic) NSArray * mapItems;

@end
