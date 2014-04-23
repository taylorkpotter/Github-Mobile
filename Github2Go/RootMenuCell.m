//
//  RootMenuCell.m
//  Github2Go
//
//  Created by Taylor Potter on 4/23/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "RootMenuCell.h"

@implementation RootMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
