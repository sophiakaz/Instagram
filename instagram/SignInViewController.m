//
//  SignInViewController.m
//  instagram
//
//  Created by sophiakaz on 7/9/19.
//  Copyright © 2019 sophiakaz. All rights reserved.
//

#import "SignInViewController.h"
#import "Parse/Parse.h"
#import "HomeViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)tapLogIn:(id)sender;
- (void)loginUser;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapLogIn:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier: @"showHomeFeed" sender:nil];
            
            // display view controller that needs to shown after successful login
        }
    }];
}


@end
