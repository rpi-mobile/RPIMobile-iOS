//
//  MasterViewController.h
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DirectoryDetailViewController;

@interface DirectoryMasterViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) DirectoryDetailViewController  *detailViewController;
@property (nonatomic, strong) NSMutableArray        *people;

@end
