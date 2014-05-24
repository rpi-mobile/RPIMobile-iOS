//
//  CampusMapViewController.m
//  RPIMobile
//
//  Created by Stephen on 2/16/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "CampusMapViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "RMDirectionService.h"
#import "CampusMapListTableViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface CampusMapViewController () <MKMapViewDelegate> {
    NSTimer *dataUpdateTimer;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}

@end

@implementation CampusMapViewController
@synthesize mapView, markers, master;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 Map Marker Types:
 0: Housing
 1: Student Life (Union, playhouse, empac)
 2: Administration
 3: Academic
 4: Athletic
 5: Dining Hall
 6: Nearby food?
*/
- (void) readMapDataFromJson {
    markers = [[NSMutableDictionary alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"map_data" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    for(NSArray *mapObject in jsonObject) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[mapObject objectAtIndex:2] floatValue], [[mapObject objectAtIndex:3] floatValue]);
        marker.title = [mapObject firstObject];
        marker.appearAnimation = kGMSMarkerAnimationNone;
        marker.map = self.mapView;
        
        
        switch ([[mapObject lastObject] intValue]) {
            case 0:
                marker.icon = [UIImage imageNamed:@"mm_student_housing.png"];
                break;
            case 1:
                marker.icon = [UIImage imageNamed:@"mm_student_life.png"];
                break;
            case 2:
                marker.icon = [UIImage imageNamed:@"mm_administration.png"];
                break;
            case 3:
                marker.icon = [UIImage imageNamed:@"mm_academic.png"];
                break;
            default:
                break;
        }
        
        [markers setObject:marker forKey:marker.title];
    }

}

- (IBAction) getCurrentLocation:(id) sender {
    
}
- (BOOL) selectPinWithTitle:(NSString *) title {
    for(GMSMarker *marker in self.markers.allValues) {
        NSLog(@"M: %@", marker);
        if( [marker.title isEqualToString:title] ) {
            [self.mapView setSelectedMarker: marker];
            [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:marker.position.latitude longitude:marker.position.longitude zoom:16.0f]];
            return YES;
        }
    }
    return NO;
}

- (void) toggleMapViewType:(id) sender {
    if (self.mapView.mapType == MKMapTypeStandard)
        self.mapView.mapType = MKMapTypeSatellite;
    else
        self.mapView.mapType = MKMapTypeStandard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readMapDataFromJson];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.84 green:0.22 blue:0.16 alpha:1.0];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:master action:@selector(show)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMapViewType:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.navigationController.navigationBar addGestureRecognizer:doubleTap];
    
    
    self.title = @"Campus Map";
    
    CLLocationCoordinate2D studentUnion =
    {42.72997, -73.676649};
//
//    MKMapCamera *camera1 = [MKMapCamera
//                            cameraLookingAtCenterCoordinate:studentUnion
//                            fromEyeCoordinate:studentUnion
//                            eyeAltitude:300.0];
//
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:studentUnion.latitude
                                                            longitude:studentUnion.longitude
                                                                 zoom:16];
//    [self.mapView setShowsUserLocation:YES];
//    [self.mapView setDelegate:self];
    [self.mapView setCamera:camera];
}

- (void) getDirectionsToMarker:(GMSMarker *) marker {

    if(!self.mapView.myLocationEnabled || self.mapView.myLocation == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot use this feature with your location services disabled for RPI Mobile. Please enable this in settings and try again!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 marker.position.latitude,
                                                                 marker.position.longitude);
    /* Load user location into waypoints */
    CLLocation *location = self.mapView.myLocation;
    NSLog(@"Location: %f, %f", location.coordinate.latitude,location.coordinate.longitude);
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                location.coordinate.latitude,location.coordinate.longitude];
    [waypointStrings_ addObject:positionString];
    
    [waypoints_ addObject:marker];
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                position.latitude, position.longitude];
    [waypointStrings_ addObject:positionString];
    
    if([waypointStrings_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        RMDirectionService *mds = [[RMDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:[MKPolyline]]
//    polyline.map = self.mapView;
    polyline.tappable = YES;
    polyline.strokeColor = [UIColor colorWithRed:0.80 green:0.17 blue:0.11 alpha:1.0];
    polyline.strokeWidth = 4.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CampusMapListTableViewController *nextView = [segue destinationViewController];
    nextView.mapView = self;
}

@end
