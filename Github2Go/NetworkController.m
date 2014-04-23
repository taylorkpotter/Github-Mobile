//
//  NetworkController.m
//  Github2Go
//
//  Created by Taylor Potter on 4/22/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "NetworkController.h"
#import "Repo.h"

#define GITHUB_CLIENT_ID @"3eef0a5d2be10c96e5c2"
#define GITHUB_CLIENT_SECRET @"fb7910675e0b05ad4ac41b1478c7d402b666e653"
#define GITHUB_CALLBACK_URI @"gitauth://git_callback"
#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_API_URL @"https://api.github.com/"
@interface NetworkController ()
@property (strong, nonatomic) NSURLSession *url;

@end
@implementation NetworkController



-(id)init
{
  self = [super init];
  
  
  if (self) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    self.url = [NSURLSession sharedSession];
    
    [self performSelector:@selector(requestOAuthAccess) withObject:nil afterDelay:.1];
  
  }
  
  
  return self;
}

-(void)requestOAuthAccess
{
  self.userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
  
  
  if (!self.userToken)
  {
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
  }

  
}


-(void)retreiveReposForCurrentUser:(void(^)(NSMutableArray *userRepoArray))completionBlock
{
  
  NSURL *userRepoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GITHUB_API_URL,@"user/repos"]];
//  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//  
//  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  
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
      newRepo.name = [obj objectForKey:@"name"];
      newRepo.html_url = [obj objectForKey:@"html_url"];
      
      [userRepoArray addObject:newRepo];
     
    }];
    
    if ([userRepoArray isKindOfClass:[NSMutableArray class]])
    {
      NSLog(@"%@", userRepoArray);
    }
    
    completionBlock(userRepoArray);

    }];
  
  

  [getDataTask resume];
  

}

  


-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
  
  NSString *code = [self getCodeFromCallBackURL:url];
  NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,code];
  NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  NSMutableURLRequest *request = [NSMutableURLRequest new];
  [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:postData];
  
  NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (error)
    {
      NSLog(@"error: %@", error.description);
    }
    
    NSLog(@" %@",response.description);
    
    //Saves the users special token to User Defaults
    self.userToken = [self convertResponseDataIntoToken:data];
    [[NSUserDefaults standardUserDefaults]setObject:self.userToken forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  }];
  
  [postDataTask resume];
  
}

-(NSString *)convertResponseDataIntoToken:(NSData*)responseData
{
  NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
  NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
  NSString *accessTokenWithCode = tokenComponents[0];
  NSArray *access_token_array = [accessTokenWithCode componentsSeparatedByString:@"="];
  
  NSLog(@"My super secret token is: %@!",access_token_array[1]);
  
  return access_token_array[1];
}

-(NSString *)getCodeFromCallBackURL:(NSURL *)callBackURL
{
  NSString *query = [callBackURL query];
//  NSLog(@" %@",query);
  NSArray *components = [query componentsSeparatedByString:@"code="];
  
  
  return [components lastObject];
  
}
@end
