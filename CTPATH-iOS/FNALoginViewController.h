//
//  FNALoginViewController.h
//  CTPATH-iOS
//
//  Created by fran on 15/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define URL_API_AUTHENTICATION @"http://localhost/otp/api/authenticate"

@class FNALoginViewController;

// This protocol defines a method to send authenticationToken to controller which implements it
@protocol LoginViewDelegate <NSObject>

-(void) loginViewController:(FNALoginViewController *) loginVC didLogIn:(NSString *) authenticationToken;

@end

@interface FNALoginViewController : UIViewController <UITextFieldDelegate>

@property (strong,nonatomic) NSString * authenticationToken;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *openCTPathWeb;

@property (weak,nonatomic) id<LoginViewDelegate> delegate;


-(IBAction) login;


- (IBAction)openCTPathWeb:(id)sender;


@end
