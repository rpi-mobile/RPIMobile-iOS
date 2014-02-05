//
//  AthleticsScheduleViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleticsScheduleViewController : UIViewController

// Custom initializer to pass information from parent view
- (id) initWithSport:(NSString *)sport andKey:(NSString *)key andGender:(NSString *)gender;

@end
