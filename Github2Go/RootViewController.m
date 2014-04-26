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

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@property (weak,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) SearchViewController *searchViewController;
@property (strong,nonatomic) NSArray *arrayOfViewControllers;
@property (strong,nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) UITapGestureRecognizer *tapToClose;
@property (strong,nonatomic) NetworkController *networkController;
@property (nonatomic) BOOL menuIsOpen;

@end

@implementation RootViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    /* Delegate Setup */
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.networkController = self.appDelegate.networkController;
    self.
  
    /* TableView Setup */
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
  
    /* View Setup */
    [self setupChildViewControllers];
    [self setupDragRecognizer];
  
    /* Gesture Setup */
    self.tapToClose = [UITapGestureRecognizer new];
  
    /* Top Level Shadow */
    self.topViewController.view.layer.shadowOffset = CGSizeMake(1, 1);
    self.topViewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.topViewController.view.layer.shadowRadius = 20.0f;
    self.topViewController.view.layer.shadowOpacity = 0.95f;

}


#pragma mark - Table View Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.arrayOfViewControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
    tableView.separatorColor = [UIColor colorWithWhite:1.000 alpha:0.300];
    tableView.backgroundColor = [UIColor colorWithRed:0.049 green:0.208 blue:0.243 alpha:0.370];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
  
    cell.textLabel.text = [self.arrayOfViewControllers[indexPath.row] title];

  return cell;
}

//This switches our view to the one selected in the table view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [self switchToViewControllerAtIndexPath:(indexPath)];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setup Child View Controllers

-(void)setupChildViewControllers
{
  
  ReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"repos"];
  repoViewController.title = @"Repo";

  UsersViewController *usersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"users"];
  usersViewController.title = @"Users";

  SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
  searchViewController.title = @"Search";
  
  self.arrayOfViewControllers = @[repoViewController,usersViewController,searchViewController];

  for (ReposViewController *repoViewController in _arrayOfViewControllers) {
    repoViewController.view.layer.shadowOffset = CGSizeMake(1, 1);
    repoViewController.view.layer.shadowColor = [[UIColor colorWithWhite:0.000 alpha:0.75] CGColor];
    repoViewController.view.layer.shadowRadius = 14.0f;
    repoViewController.view.layer.shadowOpacity = 0.8f;
    repoViewController.delegate = self;
  }

  
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
    [self resignFirstResponder];
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
