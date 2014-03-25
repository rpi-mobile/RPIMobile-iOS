//
//  AthleticsNewsTableViewCell.m
//  RPIMobile
//
//  Created by Stephen on 3/4/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "AthleticsNewsTableViewCell.h"

@implementation AthleticsNewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
//        self.articleImageView.image = [UIImage imageNamed:@"RPI_athletics_sample.jpg"];
//        self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
//        
//        UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 100, (self.articleImageView.frame.size.width * 0.75), 44)];
//        titleBackground.backgroundColor = [UIColor colorWithRed:0.80 green:0.17 blue:0.11 alpha:1.0];
//        titleBackground.alpha = 0.9f;
//        
//        self.articleTitle = [[UILabel alloc] initWithFrame:titleBackground.frame];
//        self.articleTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
//        self.articleTitle.numberOfLines = 2;
//        self.articleTitle.textColor = [UIColor whiteColor];
//        
//        [titleBackground addSubview:self.articleTitle];
//
//        [self.contentView addSubview:self.articleImageView];
//        [self.contentView addSubview:titleBackground];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
