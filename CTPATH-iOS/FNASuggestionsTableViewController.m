//
//  FNASuggestionsTableViewController.m
//  CTPATH-iOS
//
//  Created by fran on 5/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNASuggestionsTableViewController.h"
@interface FNASuggestionsTableViewController ()

@end

@implementation FNASuggestionsTableViewController

-(id) init{
    
    if(self = [super init]){
        self.mapItems = [NSArray new];
        self.startSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        self.startSearchBar.delegate = self;
        self.startSearchBar.placeholder = @"Inicio";
        self.goalSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.startSearchBar.frame.size.height, 320, 32)];
        self.goalSearchBar.delegate = self;
        self.goalSearchBar.placeholder = @"Fin";
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Ruta";
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.startSearchBar.frame.size.height * 2)];
    
    [view addSubview:self.startSearchBar];
    CGRect frame = CGRectMake(0,self.startSearchBar.frame.size.height,
                              self.goalSearchBar.frame.size.width,
                              self.startSearchBar.frame.size.height);
    
    self.goalSearchBar.frame = frame;
    
    [view addSubview:self.goalSearchBar];
    
    self.tableView.tableHeaderView = view;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe:)];
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.startSearchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}



-(void) dismissMe:(id) sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    
    request.naturalLanguageQuery = searchText; // Inserted text for searching
    
    MKLocalSearch * searcher = [[MKLocalSearch alloc] initWithRequest:request];
    
    [searcher startWithCompletionHandler:^(MKLocalSearchResponse * response, NSError * error) {
        
        if (response.mapItems.count > 0) { // Almost 1 result found
            
            // Update model and tableview
            
            self.mapItems = response.mapItems;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    }];
    
    if ([searchBar isEqual:self.startSearchBar]) {
        self.active_searchBar = START_SEARCH_BAR;
    }else{
        self.active_searchBar = GOAL_SEARCH_BAR;
    }
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.mapItems count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"point"];
     
     if(!cell){
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"point"];
     }
     
     NSString * name = [[[(MKMapItem*)([self.mapItems objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"Name"];
     
     NSString * country = [[[(MKMapItem*)([self.mapItems objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"Country"];
     
     NSString * city = [[[(MKMapItem*)([self.mapItems objectAtIndex:indexPath.row]) placemark] addressDictionary] objectForKey:@"City"];
     
     cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@",name,city,country];
     
     return cell;
 
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate suggestionsTableViewController:self didSelectMapItem:[self.mapItems objectAtIndex:indexPath.row] withSearchBar:self.active_searchBar];
    }];
   
    
    
    
    
}

@end
