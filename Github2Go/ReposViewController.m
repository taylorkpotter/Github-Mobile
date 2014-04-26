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
#import "Repo.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma - Properties

@property (strong, nonatomic) NSMutableArray *usersRepoArray;
@property (weak, nonatomic) NetworkController *networkController;
@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *repoViewTitle;


@end

@implementation ReposViewController

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
  
      self.repoViewTitle.text = @"u s e r s";

      self.appDelegate = [UIApplication sharedApplication].delegate;
  
      self.networkController = self.appDelegate.networkController;
}

#pragma mark - View Did Appear

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  

    /* Sends the message to retreive Repos for current authorized users */
    [self.networkController retreiveReposForCurrentUserWithCompletion:^(NSMutableArray *repo) {
      
      self.usersRepoArray = repo;
    
      /* Reloading table on main thread using GCD */
      dispatch_async(dispatch_get_main_queue(), ^{

        [self.tableView reloadData];
      
      });
    }];
}

/* Seek to understand what how exactly this block of code works */
-(void)pulledRepoArray:(NSMutableArray *)userRepos

{
  self.usersRepoArray = userRepos;
  
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [self pulledRepoArray:userRepos];

    });
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  cell.textLabel.text = [self.usersRepoArray[indexPath.row] repoName];
  
  return cell;
}

#pragma mark - IBActions

- (IBAction)menuPressed:(id)sender

{
  [self.delegate menuPressed];
}

@end
