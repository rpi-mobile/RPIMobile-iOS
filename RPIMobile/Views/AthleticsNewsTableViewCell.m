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
        self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//        self.articleImageView.image = [UIImage imageNamed:@"RPI_athletics_sample.jpg"];
//        self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
//        UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 275, 50)];
//        titleBackground.backgroundColor = [UIColor redColor];
//        titleBackground.alpha = 0.75f;
//        
//        self.articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 255, 40)];
//        self.articleTitle.font = [UIFont systemFontOfSize:14.0f];
//        self.articleTitle.numberOfLines = 2;
//        self.articleTitle.textColor = [UIColor whiteColor];
//
//        [self.contentView addSubview:self.articleImageView];
//        [self.contentView addSubview:titleBackground];
//        [self.contentView addSubview:self.articleTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
