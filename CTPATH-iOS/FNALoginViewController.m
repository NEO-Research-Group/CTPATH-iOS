//
//  FNALoginViewController.m
//  CTPATH-iOS
//
//  Created by fran on 15/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNALoginViewController.h"

@interface FNALoginViewController ()

@end

@implementation FNALoginViewController

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salir" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe)];
}

-(void) dismissMe{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
