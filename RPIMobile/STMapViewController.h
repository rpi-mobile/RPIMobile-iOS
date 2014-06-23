//
//  STMapViewController.h
//  Shuttle-Tracker
//
//  Created by Brendon Justin on 1/29/11.
//  Copyright 2011 Brendon Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "STDataManager.h"
#import "MasterViewController.h"
#import "MMDrawerBarButtonItem.h"

@class STJSONParser;

@interface STMapViewController : UIViewController <MKMapViewDelegate, UISplitViewControllerDelegate> {
    NSMutableArray *_stops;
    UIBarButtonItem *_locationButton;
    UIBarButtonItem *_unionButton;
    UIBarButtonItem *_flexibleSpace;
    bool _isWest;
    bool _hasLocation;
}

@property (nonatomic) MasterViewController *master;
@property (nonatomic, weak) STDataManager *dataManager;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
