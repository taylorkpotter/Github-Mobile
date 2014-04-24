//
//  Repo.m
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "Repo.h"

@implementation Repo

-(instancetype)initWithJSONDictionary:(NSDictionary *)dictionary

{
  self = [self init];
  
  self.repoURL = [dictionary objectForKey:@"html_url"];
  self.repoName = [dictionary objectForKey:@"name"];

  
  return self;
}

@end
