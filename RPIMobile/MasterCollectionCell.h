//
//  MasterCollectionCell.h
//  RPIMobile
//
//  Created by Rocco Del Priore on 5/24/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuObject.h"

@interface MasterCollectionCell : UICollectionViewCell {
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UIView *_circle;
}

@property (nonatomic) MasterMenuObject *menuObject;

@end
