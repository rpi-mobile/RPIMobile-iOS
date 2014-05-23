//
//  RMMenuCell.h
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/12/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuObject.h"

@interface MasterMenuCell : UITableViewCell {
    UILabel *_titleLabel;
    UIImageView *_imageView;
}

@property (nonatomic) MasterMenuObject *menuObject;

@end
