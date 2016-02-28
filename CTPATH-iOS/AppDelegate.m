//
//  AppDelegate.m
//  CTPATH-iOS
//
//  Created by fran on 25/2/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "AppDelegate.h"
#import "FNAMapViewController.h"


@implementation AppDelegate

-(void) makeAppStyle{
   
    UIColor *orangeCTPath = [UIColor colorWithRed:228.0f/255.0f green:82.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:orangeCTPath];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"optima" size:23.0]}];
    
    [[UIToolbar appearance] setBarTintColor:orangeCTPath];
    
    [[UIToolbar appearance] setTintColor:orangeCTPath];
    
    [[UIToolbar appearance] setTranslucent:NO];
    
    UIColor *creamColor = [UIColor colorWithRed:247.0f/255.0f green:243.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    
    [[UISearchBar appearance] setBarTintColor:creamColor];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self makeAppStyle];
    
    // Create root controller
    FNAMapViewController * rootMapVC = [[FNAMapViewController alloc] init];
    
    // Create a navigation controller as container of root controller
    UINavigationController * navVC = [[UINavigationController alloc]initWithRootViewController:rootMapVC];
    
    // Set it as root of application
    [self.window setRootViewController:navVC];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
