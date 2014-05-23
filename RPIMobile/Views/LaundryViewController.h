//
//  LaundryViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface LaundryViewController : UITableViewController// <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) MasterViewController *master;

@end
