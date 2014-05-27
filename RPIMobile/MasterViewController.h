//
//  RMMasterViewController.h
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/10/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    UIImageView *_backImageView;
    UIImageView *_frontImageView;
    UILabel *_titleLabel;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    
    NSNumber *index;
}

@property (nonatomic) NSArray *_viewControllers;
@property (nonatomic) UINavigationController *_navController;

- (void)show;

@end
