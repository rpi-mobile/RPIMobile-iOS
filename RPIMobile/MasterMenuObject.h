//
//  RMMenuObject.h
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/12/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterMenuObject : NSObject

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;

- (id)initWithViewController:(UIViewController *)aViewController andTitle:(NSString *)aTitle andImage:(UIImage *)aImage;

@end
