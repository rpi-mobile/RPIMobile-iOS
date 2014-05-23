//
//  MorningMailMasterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 11/13/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface MorningMailMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate /*MZDayPickerDataSource, MZDayPickerDelegate*/>

@property (nonatomic) MasterViewController *master;

@end
