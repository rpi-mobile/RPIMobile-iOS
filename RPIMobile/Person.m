//
//  Person.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name;
@synthesize details;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        details = dictionary;
        self.notes = @"Test Notes";
        
    }
    return self;
}

@end
