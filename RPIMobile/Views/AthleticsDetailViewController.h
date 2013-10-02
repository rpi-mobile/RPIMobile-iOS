//
//  AthleticsDetailViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/30/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface AthleticsDetailViewController : ViewPagerController

- (id)initWithSport:(NSString *) sport gender:(NSString *) gender key:(NSString *)key;

@end
