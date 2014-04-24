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

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *textToSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *searchViewTitle;

@property (weak, nonatomic) AppDelegate       *appDelegate;
@property (weak, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSMutableArray  *repoArray;



@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
      self.appDelegate = [UIApplication sharedApplication].delegate;
      self.networkController = self.appDelegate.networkController;

  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    //Instantiates our repoArray which will hold our search results
    _repoArray = [NSMutableArray new];
  
    _searchViewTitle.text = @"s e a r c h";
    _tableView.separatorColor = [UIColor colorWithRed:0.11 green:0.35 blue:0.4 alpha:1];

  
  
}

//Protcol method to handle slide out menu
- (IBAction)menuPressed:(id)sender
{
  [self.delegate menuPressed];
  
}

#pragma mark - UISearchBarDelegate

//As a delegate of UISearchBar we can perform this method to obtain the queried string
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

  [self reposForSearchString:searchBar.text];
}


#pragma mark - Search for Repositories

-(void)reposForSearchString:(NSString *)searchString
{
  //Handles a search with multiple words by adding +'s where spaces occur
  searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  
  //Does a Github API call returning repositories descending by most stars
  NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=stars&order=desc", searchString]];
  
  //Converts the NSURL into NSData
  NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
  
  //Stores the parsed jsonData in a NSDictionary
  NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];

  //Checks to ensure items has a value otherwise assume API limit exceeded
  if ([jsonDict valueForKey:@"items"]) {

    //Create temporary array to hold search results
    NSArray *tempArray = [jsonDict objectForKey:@"items"];
    
    
    //Loops through temporary array pulling out the names and urls of all the results
    for (NSDictionary *repoDict in tempArray ) {
     
      //Creates an instance of Repo passing in name/url
      Repo *tempRepo = [Repo new];
      tempRepo.name = [repoDict objectForKey:@"name"];
      tempRepo.html_url = [repoDict objectForKey:@"html_url"];
      
      //Adds the Repo instance to our Repo Array
      [self.repoArray addObject:tempRepo];

    }

    //Reload table once for finds all the names/urls
    [self.tableView reloadData];
    
  } else {
    
    //Top level if evaluated as false.
    NSLog(@"API Limit Exceeded");
  }
  
}

#pragma mark - UITableView DataSource

//Amount of rows in section based on the count of the arrayOfViewControllers
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Calls our main method below passing in the the queried string
  return self.repoArray.count;
}

//This sets up the prototype cell and gives it the name of the given object in the array
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
  cell.textLabel.text = [self.repoArray[indexPath.row] name];

  
  return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TOWebViewController *wvc = [[TOWebViewController alloc] initWithURLString:[_repoArray[indexPath.row] html_url]];
  
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:wvc] animated:YES completion:nil];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  
}


@end
