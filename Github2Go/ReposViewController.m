//
//  ReposViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "ReposViewController.h"
#import "AppDelegate.h"
#import "NetworkController.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) AppDelegate       *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSMutableArray *usersRepoArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReposViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
 
  [self.networkController retreiveReposForCurrentUser:^(NSMutableArray *userRepoArray) {
    self.usersRepoArray = userRepoArray;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [self.tableView reloadData];
    }];
  }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuPressed:(id)sender {
  [self.delegate menuPressed];
}

-(void)pulledRepoArray:(NSMutableArray *)userRepos
{
  self.usersRepoArray = userRepos;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self pulledRepoArray:userRepos];
//    [self.tableView reloadData];
  }];
  
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.usersRepoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repoCell" forIndexPath:indexPath];
  cell.textLabel.text = [self.usersRepoArray[indexPath.row] name];
  NSLog(@"%@", _usersRepoArray);
  
  return cell;
}






@end
