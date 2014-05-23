//
//  RMMasterViewController.h
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/10/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIButton *_dimView;
    UIView *_controlView;
    UITableView *_tableView;
    NSNumber *index;
}

@property (nonatomic) NSArray *_viewControllers;
@property (nonatomic) UINavigationController *_navController;

- (void)show;

@end
