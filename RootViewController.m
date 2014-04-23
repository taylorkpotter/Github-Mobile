//
//  RootViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//
#import <QuartzCore/CALayer.h>
#import "RootViewController.h"
#import "ReposViewController.h"
#import "UsersViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"

@interface RootViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,MenuProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong,nonatomic) NSArray *arrayOfViewControllers;
@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) UITapGestureRecognizer *tapToClose;
@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NetworkController *networkController;
@property (nonatomic) BOOL menuIsOpen;

@end

@implementation RootViewController

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
    //self.networkController performSelector:@selector(requestOAuthAccess) withObject:nil afterDelay:.1];
  
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    
    [self setupChildViewControllers];
    [self setupDragRecognizer];
//    self.searchViewController = [SearchViewController new];
    self.tapToClose = [UITapGestureRecognizer new];
  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View Methods


//Amount of rows in section based on the count of the arrayOfViewControllers
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.arrayOfViewControllers.count;
}

//This sets up the prototype cell and gives it the name of the given object in the array
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  tableView.separatorColor = [UIColor clearColor];
  tableView.backgroundColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.81 alpha:1.00];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.text = [self.arrayOfViewControllers[indexPath.row] title];
//  cell.textLabel.backgroundColor = [UIColor <someColorHere>];
  return cell;
}

//This switches our view to the one selected in the table view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [self switchToViewControllerAtIndexPath:(indexPath)];
}

-(void)setupChildViewControllers
{
  ReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"repos"];
  repoViewController.title = @"Repo";
  repoViewController.delegate = self;
  
  UsersViewController *usersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"users"];
  usersViewController.title = @"Users";
  usersViewController.delegate = self;
  
  SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
  searchViewController.title = @"Search";
  
  searchViewController.delegate = self;
  UINavigationController *searchNav = [[UINavigationController alloc]initWithRootViewController:searchViewController];
  searchNav.navigationBarHidden = YES;
  
  
  
  self.arrayOfViewControllers = @[repoViewController,usersViewController,searchNav];
  
  self.topViewController = self.arrayOfViewControllers[2];
  
  //Informs the parent which view controller is about to be added on screen
  [self addChildViewController:self.topViewController];

  //Adds the child viewcontrolles.view
  [self.view addSubview:self.topViewController.view];
  
  //Tells the child it did move
  [self.topViewController didMoveToParentViewController:self];
  
}

#pragma mark - Menu Button Logic


//Handles what the menu button should do when pressed.
-(void)menuPressed
{
  if (self.menuIsOpen)
  {

    [self closeMenu:nil];
    
  }
  else
  {
    [self openMenu];
  }
}

-(void)openMenu
{
  [UIView animateWithDuration:.4 animations:^{
    
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .75, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
  } completion:^(BOOL finished) {
    
    if (finished)
    {
      
      [self.tapToClose addTarget:self action:@selector(closeMenu:)];
      [self.topViewController.view addGestureRecognizer:self.tapToClose];
      self.menuIsOpen = YES;
      self.tableView.userInteractionEnabled = YES;
    }
    
  }];
  
}

-(void)closeMenu:(id)sender
{
  [UIView animateWithDuration:.5 animations:^{
    self.topViewController.view.frame = self.view.frame;
  } completion:^(BOOL finished) {
    [self.topViewController.view removeGestureRecognizer:self.tapToClose];
    self.menuIsOpen = NO;
  }];
  
  
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
  [UIView animateWithDuration:.2 animations:^{
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
  } completion:^(BOOL finished) {
    
    CGRect offScreen = self.topViewController.view.frame;
    
    [self.topViewController.view removeFromSuperview];
    
    [self.topViewController removeFromParentViewController];
    
    self.topViewController = self.arrayOfViewControllers[indexPath.row];
    
    [self addChildViewController:self.topViewController];
    
    self.topViewController.view.frame = offScreen;
    
    [self.view addSubview:self.topViewController.view];
    
    [self.topViewController didMoveToParentViewController:self];
    
    [self closeMenu:nil];
    
  }];
  
  
}

#pragma mark - Menu Panel Logic

-(void)setupDragRecognizer
{
  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
  
  panRecognizer.minimumNumberOfTouches = 1;
  panRecognizer.maximumNumberOfTouches = 1;
  
  panRecognizer.delegate = self;
  
  [self.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender
{
  
  UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
  
  CGPoint translatedPoint = [pan translationInView:self.view];
  
  if (pan.state == UIGestureRecognizerStateChanged)
  {
    if (translatedPoint.x > 0){
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
      
      [pan setTranslation:CGPointZero inView:self.view];
    }
    
  }
  
  if (pan.state == UIGestureRecognizerStateEnded)
  {
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3)
    {
      [self openMenu];
    }
    
    else
    {
      [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
      } completion:^(BOOL finished) {
        if (finished)
        {
          
          
        }
        
      }];
      
    }
    
    
  }
  
}




@end
