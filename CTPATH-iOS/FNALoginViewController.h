//
//  FNALoginViewController.h
//  CTPATH-iOS
//
//  Created by fran on 15/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <UIKit/UIKit.h>

#define URL_API_AUTHENTICATION @"http://mallba3.lcc.uma.es/otp/api/authenticate"

@interface FNALoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

-(IBAction) login;

@property (weak, nonatomic) IBOutlet UIButton *openCTPathWeb;
@end
