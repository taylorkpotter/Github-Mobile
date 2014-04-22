//
//  ReposViewController.h
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuProtocol.h"

@interface ReposViewController : UIViewController
@property (nonatomic,unsafe_unretained) id <MenuProtocol> delegate;

@end
