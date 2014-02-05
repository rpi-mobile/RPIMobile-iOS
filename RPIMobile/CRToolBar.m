//
//  CRToolBar.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "CRToolBar.h"

@interface CRToolBar ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation CRToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

static CGFloat const kDefaultColorLayerOpacity = 0.5f;

- (void)setBarTintColor:(UIColor *)barTintColor {
    [super setBarTintColor:barTintColor];
    
    if (self.colorLayer == nil) {
        self.colorLayer = [CALayer layer];
        self.colorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer addSublayer:self.colorLayer];
    }
    
    self.colorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.colorLayer != nil) {
        self.colorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}

@end
