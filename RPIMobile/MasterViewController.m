//
//  RMMasterViewController.m
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/10/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterMenuObject.h"
#import "MasterMenuCell.h"
#import "MasterCollectionCell.h"
#import "MasterCollectionLayout.h"

@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize _viewControllers, _navController;

- (UIImage *)screenshot
{
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Initialzers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = [NSNumber numberWithInt:0];
    self.view.backgroundColor = [UIColor blackColor];
	UIImage *screenshot = [self screenshot];
    
    //Create Views
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:self.view.frame];
    _titleLabel = [[UILabel alloc] init];
    _backImageView = [[UIImageView alloc] initWithImage:screenshot];
    
    //Set View Attributes
    [dismissButton addTarget:self action:@selector(slideOut) forControlEvents:UIControlEventTouchDown];
    dismissButton.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"RPI Mobile";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake((self.view.frame.size.width-_titleLabel.frame.size.width)/2, 60, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _titleLabel.alpha = 0;
    
    //Add Views
    [self.view addSubview:_backImageView];
    [self.view insertSubview:dismissButton aboveSubview:_backImageView];
    [self.view insertSubview:_titleLabel aboveSubview:_backImageView];
    
    //UICollectionView
    _layout = [[UICollectionViewFlowLayout alloc] init];
    //[_layout setItemSize:CGSizeMake(150, 180)];
    [_layout setItemSize:CGSizeMake(75, 90)];
    [_layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _layout.minimumLineSpacing = 25;
    _layout.minimumInteritemSpacing = 25;
    
    //_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-145, 110-60, self.view.frame.size.width+60, self.view.frame.size.height-110+40) collectionViewLayout:_layout];
    float collectionHeight = self.view.frame.size.height-110-40;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, (self.view.frame.size.height-collectionHeight)-30, self.view.frame.size.width-30, self.view.frame.size.height-110-40) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.alpha = 0;
    [self.view insertSubview:_collectionView aboveSubview:dismissButton];
    [_collectionView registerClass:[MasterCollectionCell class] forCellWithReuseIdentifier:@"MasterCell"];
}

#pragma mark - View Handling

- (void)slideOut {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:0.2 animations:^(void) {
        [_frontImageView removeFromSuperview];
        _titleLabel.alpha = 0;
        _collectionView.alpha = 0;
        [_backImageView setFrame:self.view.frame];
    }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [self.view removeFromSuperview];
         }
     }];
}

- (void)slideIn {
    [UIView animateWithDuration:.2 animations:^(void) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [_backImageView setFrame:CGRectMake(15, 30, _backImageView.frame.size.width-30, _backImageView.frame.size.height-60)];
    }
    completion:^ (BOOL finished) {
         if (finished) {
             UIImage *screenshot = [self screenshot];
             screenshot = [screenshot applyDarkEffect];
             _frontImageView = [[UIImageView alloc] initWithImage:screenshot];
             _frontImageView.alpha = 0;
             [self.view insertSubview:_frontImageView aboveSubview:_backImageView];
             [UIView animateWithDuration:.3 animations:^(void) {
                _frontImageView.alpha = 1;
                _titleLabel.alpha = 1;
                 _collectionView.alpha = 1;
                //_layout.itemSize = CGSizeMake(75, 90);
                //_collectionView.frame = CGRectMake(15, 110, self.view.frame.size.width-30, self.view.frame.size.height-110-40);
                //[_layout invalidateLayout];
                //_layout.minimumLineSpacing = 25;
                //_layout.minimumInteritemSpacing = 25;
             }];
         }
     }];
}

- (void)show {
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    UIImage *screenshot = [self screenshot];
    [_backImageView setImage:screenshot];
    [_navController.view addSubview:self.view];
    [[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[index intValue] inSection:0]] setSelected:true];
    [self slideIn];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MasterCell";
    MasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    cell.menuObject = (MasterMenuObject *)[_viewControllers objectAtIndex:indexPath.row];
    if (indexPath.row == [index intValue]) {
        [cell setSelected:TRUE];
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    index = [NSNumber numberWithInt:indexPath.row];
    [_navController setViewControllers:[NSArray arrayWithObject:[(MasterMenuObject *)[_viewControllers objectAtIndex:[index intValue]] viewController]]];
    [self slideOut];
}

@end