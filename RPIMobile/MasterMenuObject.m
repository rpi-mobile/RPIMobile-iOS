//
//  RMMenuObject.m
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/12/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import "MasterMenuObject.h"

@implementation MasterMenuObject
@synthesize viewController, title, image;

- (id)initWithViewController:(UIViewController *)aViewController andTitle:(NSString *)aTitle andImage:(UIImage *)aImage
{
    self = [super init];
    if (self) {
        // Custom initialization
        viewController = aViewController;
        title = aTitle;
        image = aImage;
    }
    return self;
}

@end
