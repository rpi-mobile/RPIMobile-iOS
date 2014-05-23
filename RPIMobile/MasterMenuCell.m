//
//  RMMenuCell.m
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/12/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import "MasterMenuCell.h"

@implementation MasterMenuCell
@synthesize menuObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:menuObject.title];
    [_titleLabel sizeToFit];
    [_titleLabel setFrame:CGRectMake((self.frame.size.width-_titleLabel.frame.size.width)/2, self.frame.size.height-10-_titleLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    [_titleLabel setTextColor:[UIColor blackColor]];
    //[_titleLabel setFont:[UIFont fontWithName:@"GothamHTF-Black" size:18]];
    
    if (menuObject.image != nil) {
        _imageView = [[UIImageView alloc] initWithImage:menuObject.image];
        [_imageView setFrame:CGRectMake((self.frame.size.width-_imageView.frame.size.width)/2, (self.frame.size.height-_titleLabel.frame.size.height-_imageView.frame.size.height)/2, _imageView.frame.size.width, _imageView.frame.size.height)];
        [self addSubview:_imageView];
    }
    
    [self addSubview:_titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        [_titleLabel setTextColor:[UIColor colorWithRed:0.40 green:0.78 blue:0.82 alpha:1.0]];
    }
    else {
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [_titleLabel setTextColor:[UIColor colorWithRed:0.40 green:0.78 blue:0.82 alpha:1.0]];
    }
    else {
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
}

@end
