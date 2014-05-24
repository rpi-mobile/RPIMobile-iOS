//
//  LaundryViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/20/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "JSONKit.h"
#import "DataSources.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "LaundryTableViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "LaundryViewController.h"


@interface LaundryViewController ()
@property (strong) NSArray *laundryMachines;
@property (strong) UIRefreshControl *refreshControl;
@end

@implementation LaundryViewController
@synthesize master;

- (id)init
{
    self = [super init];
    if (self) {
            // this will appear as the title in the navigation bar
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:20.0];
            label.textAlignment = NSTextAlignmentCenter;
            
            // ^-Use UITextAlignmentCenter for older SDKs.
            label.textColor = [UIColor whiteColor];
            self.navigationItem.titleView = label;
            label.text = @"Laundry Status";
            [label sizeToFit];
    }
    return self;
}

- (void) fetchLaundryStatus {

    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    NSURL *url = [NSURL URLWithString:kLaundryStatusFeedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _laundryMachines = [responseObject objectForKey:@"rooms"];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request raised an error and reset activity indicator to refresh button
        NSLog(@"Request to download laundry status1 failed: %@\n\n%@", error, [operation responseString]);
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
        // Create alert for the user to show that laundry could not be displayed
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud setLabelText:@"Error"];
        [hud setDetailsLabelText:@"Laundry Status failed to download. Please check your connection and try again."];
        [hud hide:YES afterDelay:2.0f];

    }];
        
    [operation start];
}

- (void)viewDidLoad
{
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    
    
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:master action:@selector(show)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    // Refresh controls for UITableView
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchLaundryStatus) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [super viewDidLoad];
    [self fetchLaundryStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return _laundryMachines.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"laundryCell";
    
    LaundryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *machine = [_laundryMachines objectAtIndex:indexPath.row];

    cell.titleLbl.text      = [machine objectForKey:@"Room"];
    cell.washInUseLbl.text  = [machine objectForKey:@"WashersInUse"];
    cell.dryInUseLbl.text   = [machine objectForKey:@"DryersInUse"];
    cell.washOpenLbl.text   = [machine objectForKey:@"WashersAvailable"];
    cell.dryOpenLbl.text    = [machine objectForKey:@"DryersAvailable"];
    
    return cell;
}


@end
