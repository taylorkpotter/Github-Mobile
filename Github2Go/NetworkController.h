//
//  NetworkController.h
//  Github2Go
//
//  Created by Taylor Potter on 4/22/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkController : NSObject

/* string that will hold the Auth token */
@property (strong, nonatomic) NSString *userToken;

/* method to request OAuth access with completion block */
-(void)requestOAuthAccess:(void(^)())completionOfOAuthAccess;

/* method to handle OAuth response */
-(void)handleOAuthCallbackWithURL:(NSURL *)url;

/* Returns whether user has authorization token */
-(BOOL)checkForAuthorizationToken;

/* Retreives repositories for current user with completion */
-(void)retreiveReposForCurrentUser:(void(^)(NSMutableArray *usersRepoArray))completionBlock;


@end
