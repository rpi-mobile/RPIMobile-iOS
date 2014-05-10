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
//@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic, strong) IBOutlet NSMutableDictionary *markers;

- (BOOL) selectPinWithTitle:(NSString *) title;
- (void) getDirectionsToMarker:(GMSMarker *) marker;

@end
