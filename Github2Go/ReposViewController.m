//
//  ReposViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "ReposViewController.h"
#import "NetworkController.h"
#import "AppDelegate.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *usersRepoArray;
@property (weak, nonatomic) NetworkController *networkController;
@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
      self.appDelegate = [UIApplication sharedApplication].delegate;
  
      self.networkController = self.appDelegate.networkController;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
 
  [self.networkController retreiveReposForCurrentUser:^(NSMutableArray *repo) {
    self.usersRepoArray = repo;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [self.tableView reloadData];
    }];
  }];

}


-(void)pulledRepoArray:(NSMutableArray *)userRepos

{
  self.usersRepoArray = userRepos;
  
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self pulledRepoArray:userRepos];

  }];
  
}

#pragma mark - UITableView Methods

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
  
  return cell;
}

#pragma mark - IBActions

- (IBAction)menuPressed:(id)sender

{
  [self.delegate menuPressed];
}

@end
