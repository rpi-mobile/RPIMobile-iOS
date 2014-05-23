//
//  AthleticsMainViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface AthleticsMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) MasterViewController *master;

@end
