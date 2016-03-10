//
//  FNAAboutViewController.m
//  CTPATH-iOS
//
//  Created by fran on 27/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNAAboutViewController.h"
#import "FNAColor.h"
@interface FNAAboutViewController ()

@end

@implementation FNAAboutViewController

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIColor *creamColor = [FNAColor creamColorWithAlpha:1.0];
    
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
