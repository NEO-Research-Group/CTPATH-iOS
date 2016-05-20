//
//  FNALoginViewController.m
//  CTPATH-iOS
//
//  Created by fran on 15/4/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNALoginViewController.h"

@implementation FNALoginViewController

#pragma mark - Lifecycle

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salir" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe)];
    
    self.email.clearButtonMode = UITextFieldViewModeAlways;
    
    self.password.clearButtonMode = UITextFieldViewModeAlways;
    
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Selectors

-(void) dismissKeyboard{
    
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)openCTPathWeb:(id)sender {
    
#warning TODO
    
}

-(void) dismissMe{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)login{
    
    if(![self.email.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]){
        
        NSURL * authenticationURL = [NSURL URLWithString:URL_API_AUTHENTICATION];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:authenticationURL];
        request.HTTPMethod = @"POST";
        
        [request setValue:[NSString stringWithFormat:@"%@:%@",self.email.text,self.password.text] forHTTPHeaderField:@"User-Credentials"];
        [request setValue:@"ios" forHTTPHeaderField:@"AppID"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"data %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            NSLog(@"ERROR %@",error);
            NSLog(@"response %@",response);
            dispatch_async(dispatch_get_main_queue(), ^{

                if(error){
                    [self presentAlertViewControllerWithTitle:@"Error" message:@"Ha ocurrido un problema, no es posible iniciar sesión en este momento"];
                }else if(response){
                    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
                    NSDictionary * headers = [httpResponse allHeaderFields];
                    
                    self.authenticationToken = [headers objectForKey:@"AuthenticationToken"];
                    
                    [self.delegate loginViewController:self didLogIn:self.authenticationToken];
                    
                    self.headerLabel.text = [NSString stringWithFormat:@"%@",self.email.text];
                    self.email.text = @"";
                    self.password.text = @"";
                    [self presentAlertViewControllerWithTitle:@"Error" message:@"Has iniciado sesión correctamente"];
                }
            });
        }];
        
        [postDataTask resume];
        
    }else{
        
       [self presentAlertViewControllerWithTitle:@"Error" message:@"Introduzca el correo electrónico y la contraseña"];
        
    }
    
    
}

#pragma mark - AlertViewController


-(void)presentAlertViewControllerWithTitle:(NSString *) title message:(NSString *) message{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:defaultAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark - UITextField Delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end