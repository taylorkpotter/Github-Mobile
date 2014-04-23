//
//  NetworkController.h
//  Github2Go
//
//  Created by Taylor Potter on 4/22/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>
//@protocol NetworkProtocolDelegate <NSObject>
//
//-(void)pulledRepoArray:(NSMutableArray *)userRepos;
//
//
//@end

@interface NetworkController : NSObject
@property (strong, nonatomic) NSString *userToken;
//@property (nonatomic,unsafe_unretained) id <NetworkProtocolDelegate> delegate;



-(void)requestOAuthAccess;

-(void)handleOAuthCallbackWithURL:(NSURL *)url;

-(void)retreiveReposForCurrentUser:(void(^)(NSMutableArray *usersRepoArray))completionBlock;


@end
