//
//  MorningMailCell.m
//  RPIMobile
//
//  Created by Stephen Silber on 11/13/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "MorningMailCell.h"

@implementation MorningMailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{   
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
