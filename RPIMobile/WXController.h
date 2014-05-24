//
//  WXController.h
//  SimpleWeather
//
//  Created by Ryan Nystrom on 11/11/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

@import UIKit;
#import "MasterViewController.h"

@interface WXController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic) MasterViewController *master;

@end
