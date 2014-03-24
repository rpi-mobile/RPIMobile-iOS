//
//  CampusMapViewController.m
//  RPIMobile
//
//  Created by Stephen on 2/16/14.
//  Copyright (c) 2014 Stephen Silber. All rights reserved.
//

#import "CampusMapViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface CampusMapViewController ()
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@end

@implementation CampusMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    [self.mapView setDelegate:self];
    self.title = @"Campus Map";
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.72997
                                                            longitude:-73.676649
                                                                 zoom:16];
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
