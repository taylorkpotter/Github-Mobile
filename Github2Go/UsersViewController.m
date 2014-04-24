//
//  UsersViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController ()

@end

@implementation UsersViewController

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBAction

- (IBAction)menuPressed:(id)sender {
  
  [self.delegate menuPressed];
}

@end
