//
//  UIImage+Colored.h
//
//  Created by Chadwick Wood on 9/24/10.
//

#import <UIKit/UIKit.h>


@interface UIImage (Colored)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
+ (UIImage *)image:(UIImage*)img withColor:(UIColor *)color;
@end
