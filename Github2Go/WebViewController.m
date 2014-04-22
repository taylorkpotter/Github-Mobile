//
//  WebViewController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "WebViewController.h"
#import "TOWebViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.searchResultURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:604800];
  [self.webView loadRequest:urlRequest];
  NSLog(@"%@", urlRequest);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
