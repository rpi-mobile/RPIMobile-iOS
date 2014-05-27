//
//  MasterCollectionLayout.h
//  RPIMobile
//
//  Created by Rocco Del Priore on 5/24/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCollectionLayout : UICollectionViewLayout


@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat titleHeight;

@end
