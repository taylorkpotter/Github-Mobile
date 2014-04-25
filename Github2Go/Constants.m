//
//  Constants.m
//  Github2Go
//
//  Created by Taylor Potter on 4/24/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "Constants.h"



@implementation Constants

NSString* const GITHUB_CLIENT_ID = @"3eef0a5d2be10c96e5c2";
NSString* const GITHUB_CLIENT_SECRET = @"fb7910675e0b05ad4ac41b1478c7d402b666e653";
NSString* const GITHUB_CALLBACK_URI = @"gitauth://git_callback";
NSString* const GITHUB_OAUTH_URL = @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";
NSString* const GITHUB_API_URL = @"https://api.github.com/";
NSString* const GITHUB_USERS_REPOS_URL = @"https://api.github.com/user/repos?sort=updated&order=desc";

@end
