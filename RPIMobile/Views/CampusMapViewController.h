//
//  CampusMapViewController.h
//  RPIMobile
//
//  Created by Stephen on 2/16/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface CampusMapViewController : UIViewController <GMSMapViewDelegate>
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) IBOutlet NSMutableArray *markers;

- (BOOL) selectPinWithTitle:(NSString *) title;

@end
