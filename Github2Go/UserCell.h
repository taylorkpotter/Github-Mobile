//
//  UserCell.h
//  Github2Go
//
//  Created by Taylor Potter on 4/25/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
