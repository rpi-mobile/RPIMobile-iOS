//
//  MenuItemCell.h
//  RPIMobile
//
//  Created by Stephen on 2/14/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *itemTitle;
@property (nonatomic, strong) IBOutlet UIImageView *itemIconView;
@property (nonatomic, strong) IBOutlet UIImage *icon;

@end
