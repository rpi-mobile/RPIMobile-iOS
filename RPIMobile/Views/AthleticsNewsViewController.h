//
//  AthleticsNewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleticsNewsViewController : UIViewController


@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) UIViewController *previousView;
- (id)initWithSport:(NSString *) sport andKey:(NSString *) key andPreviousViewController:(UIViewController *) view;

@end
