//
//  NewsFeedCell.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell
@synthesize title, subtitle, cellImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImage.center = CGPointMake(((self.cellImage.frame.size.width/2) + self.cellImage.frame.origin.x), (self.cellImage.frame.size.height/2));
        self.cellImage.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
