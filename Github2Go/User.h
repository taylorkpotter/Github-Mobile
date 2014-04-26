//
//  User.h
//  Github2Go
//
//  Created by Taylor Potter on 4/24/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *avatarURL, *followers, *userName, *userID, *repoName;
@property (strong, nonatomic) UIImage *avatarImage;


-(instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;



@end
