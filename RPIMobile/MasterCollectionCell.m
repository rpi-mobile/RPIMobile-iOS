//
//  MasterCollectionCell.m
//  RPIMobile
//
//  Created by Rocco Del Priore on 5/24/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "MasterCollectionCell.h"
#import "UIImage+Colored.h"

@implementation MasterCollectionCell
@synthesize menuObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    //[_titleLabel setFont:[UIFont fontWithName:@"GothamHTF-Black" size:18]];
    
    if (menuObject.image != nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage image:menuObject.image withColor:[UIColor whiteColor]]];
        /*if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width/2, _imageView.frame.size.height/2);
        }*/
        _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width/2, _imageView.frame.size.height/2);
        [_imageView setFrame:CGRectMake((self.frame.size.width-_imageView.frame.size.width)/2, ((self.frame.size.height-_titleLabel.frame.size.height-_imageView.frame.size.height)/2)-5, _imageView.frame.size.width, _imageView.frame.size.height)];
        [self addSubview:_imageView];
    }
    
    float size = self.frame.size.height-_titleLabel.frame.size.height-10;
    _circle = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-size)/2, 0, size, size)];
    _circle.layer.cornerRadius = size/2;
    _circle.backgroundColor = [UIColor clearColor];
    _circle.layer.borderColor = [UIColor whiteColor].CGColor;
    _circle.layer.borderWidth = 3.0f;
    [self addSubview:_circle];
    
    [self addSubview:_titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    UIColor *myBlue = [UIColor colorWithRed:0.00 green:0.44 blue:0.87 alpha:1.0];
    UIColor *myRed = [UIColor colorWithRed:0.86 green:0.34 blue:0.29 alpha:1.0];
    if (selected) {
        //[_titleLabel setTextColor:myBlue];
        [_circle.layer setBorderColor:myBlue.CGColor];
    }
    else {
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_circle.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
}

- (void)setSelected:(BOOL)selected {
    UIColor *myBlue = [UIColor colorWithRed:0.00 green:0.44 blue:0.87 alpha:1.0];
    UIColor *myRed = [UIColor colorWithRed:0.86 green:0.34 blue:0.29 alpha:1.0];

    if (selected) {
        //[_titleLabel setTextColor:myBlue];
        [_circle.layer setBorderColor:myBlue.CGColor];
    }
    else {
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_circle.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
