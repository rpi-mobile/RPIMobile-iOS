//
//  TweetCell.m
//  RPIMobile
//
//  Created by Stephen Silber on 11/9/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "TweetCell.h"



@implementation TweetCell
@synthesize date, username, tweet, profileImage;

+ (TweetCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    TweetCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[TweetCell class]]) {
            customCell = (TweetCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
