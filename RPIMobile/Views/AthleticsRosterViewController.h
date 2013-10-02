//
//  AthleticsRosterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleticsRosterViewController : UIViewController

// Custom initializer to pass information from parent view
- (id) initWithSport:(NSString *)sport andKey:(NSString *)key andGender:(NSString *)gender andViewController:(UIViewController *) view;

@end
