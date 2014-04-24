//
//  Repo.h
//  Github2Go
//
//  Created by Taylor Potter on 4/21/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property (nonatomic, strong) NSString *repoURL, *repoName;

-(instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;


@end
