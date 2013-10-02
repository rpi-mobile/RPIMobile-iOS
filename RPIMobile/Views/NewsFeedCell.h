//
//  NewsFeedCell.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell {
    IBOutlet UILabel *title, *subtitle;
    IBOutlet UIImageView *cellImage;
}

@property (strong) IBOutlet UILabel *title, *subtitle;
@property (strong) IBOutlet UIImageView *cellImage;

@end
