//
//  AppDelegate.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerVisualState.h"
#import "SideMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CRNavigationController.h"

#import "NewsFeedViewController.h"
#import "AthleticsMainViewController.h"
#import "SideMenuViewController.h"
#import "WebViewController.h"

//View Controllers
#import "MorningMailMasterViewController.h"
#import "DirectoryMasterViewController.h"
#import "NewsFeedViewController.h"
#import "LaundryViewController.h"
#import "TwitterFeedViewController.h"
#import "AthleticsMainViewController.h"
#import "CampusMapViewController.h"
#import "WXController.h"
#import "CRNavigationController.h"

//MasterView Stuff
#import "MasterViewController.h"
#import "MasterMenuObject.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // AthleticsMainViewController *mainView = [[AthleticsMainViewController alloc] init];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SideMenu" bundle:nil];
    
    /*SideMenuViewController *leftDrawer = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    _navController = [[CRNavigationController alloc] initWithRootViewController:mainView];
    
    // Initialize the side drawer for menu and navigation
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:_navController
                                             leftDrawerViewController:leftDrawer
                                             rightDrawerViewController:nil];
    [drawerController setOpenDrawerGestureModeMask:(MMOpenDrawerGestureModePanningNavigationBar | MMOpenDrawerGestureModeBezelPanningCenterView)];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:MAXFLOAT]];
    [drawerController setShouldStretchDrawer:NO];
    [drawerController setMaximumLeftDrawerWidth:85.0f];*/
    
    //Create Storyboards
    UIStoryboard *morningMailStoryboard = [UIStoryboard storyboardWithName:@"MorningMailStoryboard_iPhone" bundle:nil];
    UIStoryboard *directoryStoryboard = [UIStoryboard storyboardWithName:@"DirectoryStoryboard_iPhone" bundle:nil];
    UIStoryboard *laundryStoryboard = [UIStoryboard storyboardWithName:@"LaundryStoryboard_iPhone" bundle:nil];
    UIStoryboard *twitterStoryboard = [UIStoryboard storyboardWithName:@"TwitterStoryboard_iPhone" bundle:nil];
    UIStoryboard *campusMapSotryboard = [UIStoryboard storyboardWithName:@"CampusMapViewController" bundle:nil];
    
    //Create View Controlelrs
    MorningMailMasterViewController *morningMailView = [morningMailStoryboard instantiateViewControllerWithIdentifier:@"morningMail"];
    DirectoryMasterViewController *directoryView = [directoryStoryboard instantiateViewControllerWithIdentifier:@"directoryView"];
    NewsFeedViewController *newsFeedView = [[NewsFeedViewController alloc] init];
    LaundryViewController *laundryView = [laundryStoryboard instantiateViewControllerWithIdentifier:@"laundryView"];
    TwitterFeedViewController *twitterView = [twitterStoryboard instantiateViewControllerWithIdentifier:@"twitterView"];
    AthleticsMainViewController *athleticsView = [[AthleticsMainViewController alloc] init];
    CampusMapViewController *campusMapView = [campusMapSotryboard instantiateViewControllerWithIdentifier:@"campusMapView"];
    WXController *weatherView = [[WXController alloc] init];
    
    //MenuObjects
    MasterMenuObject *morningMailMenu = [[MasterMenuObject alloc] initWithViewController:morningMailView andTitle:@"Morning\nMail" andImage:[UIImage imageNamed:@"envelope"]];
    MasterMenuObject *directoryMenu = [[MasterMenuObject alloc] initWithViewController:directoryView andTitle:@"Directory" andImage:[UIImage imageNamed:@"group"]];
    //MasterMenuObject *newsFeedMenu = [[MasterMenuObject alloc] initWithViewController:newsFeedView andTitle:@"News Feed" andImage:nil];
    MasterMenuObject *laundryMenu = [[MasterMenuObject alloc] initWithViewController:laundryView andTitle:@"Laundry" andImage:[UIImage imageNamed:@"time"]];
    MasterMenuObject *twitterMenu = [[MasterMenuObject alloc] initWithViewController:twitterView andTitle:@"Social\nFeed" andImage:[UIImage imageNamed:@"twitter"]];
    MasterMenuObject *athleticsMenu = [[MasterMenuObject alloc] initWithViewController:athleticsView andTitle:@"Athletics" andImage:[UIImage imageNamed:@"trophy"]];
    MasterMenuObject *campusMenu = [[MasterMenuObject alloc] initWithViewController:campusMapView andTitle:@"Campus\nMap" andImage:[UIImage imageNamed:@"location"]];
    MasterMenuObject *weatherMenu = [[MasterMenuObject alloc] initWithViewController:weatherView andTitle:@"Weather" andImage:[UIImage imageNamed:@"cloud"]];
    
    //Create Master and fill
    UIStoryboard *masterStoryboard = [UIStoryboard storyboardWithName:@"Navigation" bundle:nil];
    MasterViewController *master = [masterStoryboard instantiateViewControllerWithIdentifier:@"masterView"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:athleticsView];
    master._viewControllers = [[NSArray alloc] initWithObjects:athleticsMenu, twitterMenu, campusMenu, laundryMenu, morningMailMenu, weatherMenu,directoryMenu, nil];
    master._navController = navigation;
    morningMailView.master = master;
    directoryView.master = master;
    newsFeedView.master = master;
    laundryView.master = master;
    twitterView.master = master;
    athleticsView.master = master;
    campusMapView.master = master;
    weatherView.master = master;
    
    //Set disk cache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [GMSServices provideAPIKey:@"AIzaSyBn7BdKND4vd9XpI2ob-vZflie3SjKSsz4"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigation;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.window.tintColor = [UIColor whiteColor]; // Changes the uinavigationbar button colors (back button)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // Changes status bar text color to white
    }


    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RPIMobile" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RPIMobile.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
