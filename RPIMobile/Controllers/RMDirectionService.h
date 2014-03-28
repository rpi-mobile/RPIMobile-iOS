//
//  RMDirectionService.h
//  RPIMobile
//
//  Created by Stephen on 3/25/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDirectionService : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate;
@end
