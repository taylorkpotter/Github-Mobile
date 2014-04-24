//
//  User.m
//  Github2Go
//
//  Created by Taylor Potter on 4/24/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithJSONDictionary:(NSDictionary *)dictionary

{
  self = [self init];
  
  self.avatarURL = [dictionary objectForKey:@"avatar_url"];
  self.followers = [dictionary objectForKey:@"followers_url"];
  self.userID = [dictionary objectForKey:@"id"];
  self.userName = [dictionary objectForKey:@"login"];
  
  return self;
}

@end


