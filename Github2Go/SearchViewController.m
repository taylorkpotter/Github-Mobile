//
//  SearchViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"
#import "TOWebViewController.h"
#import "AppDelegate.h"
#import "Repo.h"
#import "User.h"

#define GITHUB_API_URL @"https://api.github.com/"


@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *searchViewTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *identifier;

@property (weak, nonatomic) NetworkController *networkController;
@property (weak, nonatomic) AppDelegate       *appDelegate;
@property (strong, nonatomic) NSMutableArray  *searchResults;


@end

@implementation SearchViewController

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];

      /* Instantiates our search results array which will hold our repo/users queries */
      _searchResults = [NSMutableArray new];
  
      /* Become delegate of App Delegate */
      self.appDelegate = [UIApplication sharedApplication].delegate;
  
      /* Become delegate of Network Controller */
      self.networkController = self.appDelegate.networkController;

  
}

#pragma mark - View Did Appear

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    _searchViewTitle.text = @"s e a r c h";
    _tableView.separatorColor = [UIColor colorWithRed:0.11 green:0.35 blue:0.4 alpha:1];
  
}

/*Protcol method to handle slide out menu */
- (IBAction)menuPressed:(id)sender
{
  [self.delegate menuPressed];
}

#pragma mark - UISearchBarDelegate

//As a delegate of UISearchBar we can perform this method to obtain the queried string
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [self.searchResults removeAllObjects];
  
  self.identifier = [NSString new];
  
  if (searchBar.selectedScopeButtonIndex) {
    self.identifier = @"searchUsers";
    [self reposForSearchString:[NSString stringWithFormat:@"search/users?q=%@", searchBar.text]];
 
  } else {
    self.identifier = @"searchRepos";
    [self reposForSearchString:[NSString stringWithFormat:@"search/repositories?q=%@&sort=stars&order=desc", searchBar.text]];
  }
  [self.tableView reloadData];
}



#pragma mark - Search for Repositories

-(void)reposForSearchString:(NSString *)searchString
{
  //Handles a search with multiple words by adding +'s where spaces occur
  searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  NSLog(@" This is the passed in text %@", searchString);
  
  //Does a Github API call returning repositories descending by most stars
  NSURL *jsonURLForRepos = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GITHUB_API_URL,searchString]];
  
  //Converts the NSURL into NSData
  NSData *jsonData = [NSData dataWithContentsOfURL:jsonURLForRepos];
  
  //Stores the parsed jsonData in a NSDictionary
  NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];

  //Checks to ensure items has a value otherwise assume API limit exceeded
  if ([jsonDict valueForKey:@"items"]) {

    //Create temporary array to hold search results
    NSArray *tempArray = [jsonDict objectForKey:@"items"];
    
    if ([self.identifier isEqualToString:@"searchRepos"]) {

      for (NSDictionary *repoDict in tempArray ) {
        
        Repo *tempRepo = [[Repo alloc] initWithJSONDictionary:repoDict];
        
        [self.searchResults addObject:tempRepo];
      }
    
    } else {
      
      for (NSDictionary *userDict in tempArray ) {
        
        //Creates an instance of Repo passing in name/url
        User *tempUser = [[User alloc] initWithJSONDictionary:userDict];
        
        //Adds the Repo instance to our Repo Array
        [self.searchResults addObject:tempUser];
      }
    }
  

    //Reload table once for finds all the names/urls
    [self.tableView reloadData];
    
  } else {
    
    //Top level if evaluated as false.
    NSLog(@"API Limit Exceeded");
  }
  
}

#pragma mark - UITableView

//Amount of rows in section based on the count of the arrayOfViewControllers
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Calls our main method below passing in the the queried string
  return self.searchResults.count;
}

//This sets up the prototype cell and gives it the name of the given object in the array
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //add scope to determine what scope will be
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
  
//  cell.textLabel.text = [self.searchResults[indexPath.row] name];

  if ([self.identifier isEqualToString:@"searchRepos"]) {
    cell.textLabel.text = [self.searchResults[indexPath.row] repoName];
  } else {
    cell.textLabel.text = [self.searchResults[indexPath.row] userName];
  }
  
  return cell;
}

//This method uses a CocoaPod to instantiate a custom WebViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TOWebViewController *wvc = [[TOWebViewController alloc] initWithURLString:[_searchResults[indexPath.row] repoURL]];
  
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:wvc] animated:YES completion:nil];
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end
