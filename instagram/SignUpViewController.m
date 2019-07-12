//
//  SignUpViewController.m
//  instagram
//
//  Created by sophiakaz on 7/9/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)tapSignUp:(id)sender;
- (void)registerUser;

@end

@implementation SignUpViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tapSignUp:(id)sender {
    [self registerUser];
    
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier: @"showHomeFeed" sender:nil];
            
            // manually segue to logged in view
        }
    }];
}


@end
