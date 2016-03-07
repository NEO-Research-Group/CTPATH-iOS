//
//  FNAAboutViewController.m
//  CTPATH-iOS
//
//  Created by fran on 27/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAAboutViewController.h"

@interface FNAAboutViewController ()

@end

@implementation FNAAboutViewController

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIColor *creamColor = [UIColor colorWithRed:247.0f/255.0f green:243.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    
    [self.view setBackgroundColor:creamColor];
    
    [self.infoTextView setBackgroundColor:creamColor];
    
    [self.navigationController setToolbarHidden:YES];
    
    self.title = @"About";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
