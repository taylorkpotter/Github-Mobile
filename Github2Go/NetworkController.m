//
//  NetworkController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/22/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "NetworkController.h"
#import "Repo.h"

@interface NetworkController ()


@property (strong, nonatomic) NSURLSession *url;

/* Need a better understanding of why I'm passing a block in as a property */
@property (copy, nonatomic) void (^completionOfOAuthAccess)();

@end
@implementation NetworkController



-(id)init
{
  self = [super init];
  
  
  if (self) {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    self.url = [NSURLSession sessionWithConfiguration:configuration];
  }
  
  
  return self;
}

-(void)requestOAuthAccess:(void(^)())completionOfOAuthAccess;
{
  
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
  
    //Not totally sure what this line is doing
    _completionOfOAuthAccess = completionOfOAuthAccess;
  
    //Not totally sure what this line is doing
    [[UIApplication sharedApplication] performSelector:@selector(openURL:)
                                          withObject:[NSURL URLWithString:urlString]
                                          afterDelay:.1];
  
}


-(void)retreiveReposForCurrentUserWithCompletion:(void(^)(NSMutableArray *userRepoArray))completionBlock
{
  NSURL *userRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GITHUB_API_URL,@"user/repos?sort=updated&order=desc"]];
  
  NSMutableURLRequest *request = [NSMutableURLRequest new];
  [request setURL:userRepoURL];
  [request setHTTPMethod:@"GET"];
  [request setValue:[NSString stringWithFormat:@"token %@", _userToken] forHTTPHeaderField:@"Authorization"];
  
  NSURLSessionDataTask *getDataTask = [self.url dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"Response is %@", response.description);
    
    NSMutableArray *tempJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *userRepoArray = [NSMutableArray new];

    [tempJSONArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Repo *newRepo = [Repo new];
      newRepo.repoName = [obj objectForKey:@"name"];
      newRepo.repoURL = [obj objectForKey:@"html_url"];
      
      [userRepoArray addObject:newRepo];
     
    }];
    
    if ([userRepoArray isKindOfClass:[NSMutableArray class]])
    {
      NSLog(@"%@", userRepoArray);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completionBlock(userRepoArray);
    });
    
  }];
  


  [getDataTask resume];
  

}

  


-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
  
  NSString *code = [self getCodeFromCallBackURL:url];
  
  NSString *postString = [NSString stringWithFormat:@"https://github.com/login/oauth/access_token?client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];

  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  
  [[session dataTaskWithURL:[NSURL URLWithString:postString]
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           
           if (!error) {
             
             self.userToken = [self convertResponseDataIntoToken:data];
             [[NSUserDefaults standardUserDefaults]setObject:self.userToken forKey:@"userToken"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             dispatch_async(dispatch_get_main_queue(), ^{
               self.completionOfOAuthAccess();
             });
             
           } else {
             NSLog(@"%@", error.description);
           }
           
         }]resume];
}

#pragma mark - Returns code from callBackURL

-(NSString *)getCodeFromCallBackURL:(NSURL *)callBackURL
{
  NSString *query = [callBackURL query];
  NSArray *components = [query componentsSeparatedByString:@"code="];
  return [components lastObject];
  
}

#pragma mark - Convert Response Data Into Token

-(NSString *)convertResponseDataIntoToken:(NSData*)responseData

  {
  NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
  
  NSArray  *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
  
  NSString *accessTokenWithCode = tokenComponents[0];
  
  NSArray  *access_token_array  = [accessTokenWithCode componentsSeparatedByString:@"="];
  
  return access_token_array[1];
} 


#pragma mark - Check If User Has Authorization Token

-(BOOL)checkForAuthorizationToken
{
  
  if (self.userToken)
  {
    return YES;
  
  } else {
    
      NSLog(@"You need to get a token first!");
    
    return NO;
  }
}



@end
