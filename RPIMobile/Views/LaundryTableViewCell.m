//
//  LaundryTableViewCell.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/3/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "LaundryTableViewCell.h"

@implementation LaundryTableViewCell

@synthesize titleLbl, washOpenLbl, washInUseLbl, dryOpenLbl, dryInUseLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
