//
//  CampusMapListViewControllerTableViewController.h
//  RPIMobile
//
//  Created by Stephen on 3/25/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusMapListTableViewController : UITableViewController

@property (nonatomic, strong) CampusMapViewController *mapView;
@property (nonatomic, strong) NSDictionary *mapMarkers;

@end
