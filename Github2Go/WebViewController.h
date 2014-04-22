//
//  WebViewController.h
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (nonatomic, strong)IBOutlet UIWebView *webView;
@property (nonatomic, strong)NSString *searchResultURL;


@end
