//
//  STLaterEtasViewController.m
//  Shuttle-Tracker
//
//  Created by Brendon Justin on 4/30/11.
//  Copyright 2011 Brendon Justin. All rights reserved.
//

#import "STExtraEtasViewController.h"
#import "STDataUrls.h"
#import "STETA.h"
#import "STFavoriteStop.h"
#import "STRoute.h"
#import "STStop.h"
#import "STJSONParser.h"
#import "STDataManager.h"


@interface STExtraEtasViewController ()

@property (nonatomic, strong) NSURL *etasUrl;
@property (nonatomic, strong) STJSONParser *extraEtasParser;
@property (nonatomic, strong) NSDate *lastEtaRefresh;
@property (nonatomic, strong) NSArray *etas;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;


- (void)getExtraEtas;
- (void)delayedTableReload;
- (void)unsafeDelayedTableReload;
- (void)settingChanged:(NSNotification *)notification;

@end


@implementation STExtraEtasViewController

- (id)initWithStop:(STStop *)stop forRouteNumber:(NSNumber *)routeNumber {
    //  if ((self = [self initWithStyle:UITableViewStyleGrouped])) {
    if ((self = [super init])) {
        self.stop = stop;
        self.routeNum = routeNumber;
        self.title = stop.shortName;
        
        self.lastEtaRefresh = nil;
        
        self.etasUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&rt=%d&st=%@",
                                                      kSTExtraEtasUrl, [routeNumber intValue], stop.idTag]];
        
        self.extraEtasParser = [[STJSONParser alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.useRelativeTimes = [[defaults objectForKey:@"useRelativeTimes"] boolValue];
        
        self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(toggleFavorite:)];
        self.navigationItem.rightBarButtonItem = self.favoriteButton;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)getExtraEtas {
    self.lastEtaRefresh = [NSDate dateWithTimeIntervalSinceNow:0];
    
    dispatch_queue_t extraEtasQueue = dispatch_queue_create("com.abstractedsheep.extraetasqueue", NULL);
    dispatch_async(extraEtasQueue, ^{
        NSError *theError = nil;
        NSString *jsonString = [NSString stringWithContentsOfURL:self.etasUrl
                                                        encoding:NSUTF8StringEncoding
                                                           error:&theError];
        if (theError) {
            NSLog(@"Error retrieving JSON data");
        } else {
            [self.extraEtasParser performSelectorOnMainThread:@selector(parseExtraEtasFromJson:)
                                                   withObject:jsonString
                                                waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(delayedTableReload)
                                   withObject:nil
                                waitUntilDone:NO];
        }
    });
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Set the favorite/unfavorite button appearance
    //  based on the status of the view's associated stop.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([STFavoriteStop class])
                                                         inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    [request setFetchLimit:1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(route.routeId == %@) AND (stop.idTag == %@)",
                              self.routeNum, self.stop.idTag];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    int numStops = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (error != nil) {
        //  handle error
    }
    
    
    if (numStops > 0) {
        self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                            target:self
                                                                            action:@selector(toggleFavorite:)];
    } else {
        self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(toggleFavorite:)];
    }
    
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
    
    [self getExtraEtas];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateTimer = [NSTimer timerWithTimeInterval:10.0f target:self
                                             selector:@selector(getExtraEtas)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.updateTimer invalidate];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//  Handle the "Favorite/Unfavorite" button
- (void)toggleFavorite:(id)sender {
    BOOL added = NO;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([STFavoriteStop class])
                                                         inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    [request setFetchLimit:1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(route.routeId == %@) AND (stop.idTag == %@)",
                              self.routeNum, self.stop.idTag];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *stops = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        //  handle error
    } else if ([stops count] > 0) {
        //  Remove the favorite stop
        [self.managedObjectContext deleteObject:[stops objectAtIndex:0]];
    } else {
        //  Create the favorite stop
        STFavoriteStop *favStop = (STFavoriteStop *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STFavoriteStop class])
                                                                                  inManagedObjectContext:self.managedObjectContext];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([STRoute class])
                                                             inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        [request setFetchLimit:1];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(routeId == %@)", self.routeNum];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *routes = [self.managedObjectContext executeFetchRequest:request error:&error];
        if ([routes count] > 0) {
            favStop.route = [routes objectAtIndex:0];
            favStop.stop = self.stop;
            
            // Save the context.
            error = nil;
            if (![self.managedObjectContext save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate.
                 You should not use this function in a shipping application, although
                 it may be useful during development.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
            
            added = YES;
        }
    }
    
    
    if (added) {
        self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                            target:self
                                                                            action:@selector(toggleFavorite:)];
    } else {
        self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(toggleFavorite:)];
    }
    
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  Return the number of sections.
    //  Only one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //  If there are no etas, then return a Loading... cell
    return [self.etas count] ? ([self.etas count] > 5 ? 5 : [self.etas count]) : 1;
}


//  Use the name of the stop as the section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.stop.name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExtraEtaCell";
    int row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //  Init the cell such that it has main text, black and left aligned, and secondary text,
        //  blue and right aligned
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSNumber *eta = nil;
    
    //  If there are no etas, then return a Loading... cell
    
    if ([self.etas count] == 0  && indexPath.section == 0 && indexPath.row == 0) {
        //  The main text label, left aligned and black in UITableViewCellStyleValue1
        cell.textLabel.text = @"Loading...";
    } else if (row < [self.etas count]) {
        eta = [self.etas objectAtIndex:row];
        
        //  If the EtaWrapper was found, add the stop info and the ETA
        if (eta) {
            //  The main text label, left aligned and black in UITableViewCellStyleValue1
            unsigned int nthShuttle = indexPath.row + 1;
            NSString *shuttleNoString;
            
            if (nthShuttle == 1) {
                shuttleNoString = @"1st ";
            } else if (nthShuttle == 2) {
                shuttleNoString = @"2nd ";
            } else if (nthShuttle == 3) {
                shuttleNoString = @"3rd ";
            } else {
                shuttleNoString = [NSString stringWithFormat:@"%uth", nthShuttle];
            }
            
            cell.textLabel.text = [shuttleNoString stringByAppendingString:@" Shuttle:"];
            
            //  The secondary text label, right aligned and blue in UITableViewCellStyleValue1
            if (self.useRelativeTimes) {
                int minutesToEta = 0;
                NSDate *arrivalDate = [self.lastEtaRefresh dateByAddingTimeInterval:[eta intValue] / 1000];
                minutesToEta = (int)([arrivalDate timeIntervalSinceNow] / 60);
                
                //  Grammar for one vs. more than one
                if (minutesToEta >= 1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d min.", minutesToEta];
                }
                else if (minutesToEta < 1) {
                    //  Cover our ears and show imminent and past times the same way
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"< 1 min."];
                }
            } else {
                //  Show ETAs as timestamps
                cell.detailTextLabel.text = [self.timeDisplayFormatter stringFromDate:[self.lastEtaRefresh dateByAddingTimeInterval:[eta intValue] / 1000]];
            }
        } else {
            cell.detailTextLabel.text = @"————";
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Navigation logic may go here. Create and push another view controller.
    //  Do nothing
}


//  Call unsafeDelayedTableReload on the main thread
- (void)delayedTableReload {
    [self performSelectorOnMainThread:@selector(unsafeDelayedTableReload)
                           withObject:nil waitUntilDone:NO];
}


//  Reload the table on a short delay, usually for a data change
- (void)unsafeDelayedTableReload {
    
    self.etas = [self.extraEtasParser extraEtas];
    
    [NSTimer scheduledTimerWithTimeInterval:0.125f
                                     target:self.tableView
                                   selector:@selector(reloadData)
                                   userInfo:nil
                                    repeats:NO];
}

//  InAppSettingsKit sends out a notification whenever a setting is changed in the
//  settings view inside the app.  settingChanged handles switching between absolute
//  and relative times for updates and ETAs.  Other objects may also do something
//  when a setting is changed.
- (void)settingChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    //  Set the date format to 24 hour time if the user has set Use 24 Hour Time to true.
    if ([[notification object] isEqualToString:@"useRelativeTimes"]) {
        if ([[info objectForKey:@"useRelativeTimes"] boolValue]) {
            self.useRelativeTimes = YES;
        } else {
            self.useRelativeTimes = NO;
        }
        
        [self.tableView reloadData];
    }
}


@end
