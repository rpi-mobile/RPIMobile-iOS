//
//  TweetCell.h
//  RPIMobile
//
//  Created by Stephen Silber on 11/9/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTweetLabelWidth 234

@interface TweetCell : UITableViewCell {
    IBOutlet UILabel *tweet, *username, *date;
    IBOutlet UIImageView *profileImage;
}

@property (strong) IBOutlet UILabel *tweet, *username, *date;
@property (strong) IBOutlet UIImageView *profileImage;

+ (TweetCell *)cellFromNibNamed:(NSString *)nibName;

@end
