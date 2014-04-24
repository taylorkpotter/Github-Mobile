//
//  LoginViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/23/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;

@end

@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
  
    if ([self.networkController checkForAuthorizationToken]) {
      [self performSegueWithIdentifier:@"goToRoot" sender:self];
   
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonPressed:(id)sender {
  
  [self.networkController requestOAuthAccess:^{
    
    
  [self performSegueWithIdentifier:@"goToRoot" sender:self];
  }];

}





@end
