//
//  AthleticsRosterViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "JSONKit.h"
#import "DataSources.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperation.h"
#import "AthleticsRosterViewController.h"

@interface AthleticsRosterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong) UITableView *tableView;
@property (strong) NSArray *roster;
@property (strong) NSString *key, *sport, *gender;
@property (strong) UIViewController *previousView;

@end

@implementation AthleticsRosterViewController

- (id) initWithSport:(NSString *)sport andKey:(NSString *)key andGender:(NSString *)gender andViewController:(UIViewController *)view
{
    if (self = [super init]) {
        _previousView = view;
        _key = key;
        _gender = gender;
        _sport = sport;
    }
    return self;
}

- (void) downloadRoster {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAthleticsRosterUrl, _key]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Finished download of %i objects", [[responseObject objectForKey:@"players"] count]);
        _roster = [responseObject objectForKey:@"players"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Request raised an error
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Request to download roster failed: %@\n\n%@", error, [operation responseString]);
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setRowHeight:55.0f];
    
    [self.view addSubview:_tableView];
    [self downloadRoster];
    
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
    return _roster.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *athlete = [_roster objectAtIndex:indexPath.row];
    NSLog(@"Athlete: %@", athlete);
    
    cell.textLabel.text = [athlete objectForKey:@"name"];
    cell.detailTextLabel.text = [athlete objectForKey:@"hometown"];
    
    // Get the Layer of any view
    CALayer * l = [cell.imageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0];
    
    NSString *imageName = [_gender isEqualToString:@"men"] ? @"user_male.png" : @"user_female.png";
    
    [cell.imageView setImageWithURL:[athlete objectForKey:@"image"] placeholderImage:[UIImage imageNamed:imageName]];
    NSLog(@"Cell dimensions: %f, %f", cell.imageView.frame.size.height, cell.imageView.frame.size.width);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *athlete = [_roster objectAtIndex:indexPath.row];
    WebViewController *nextView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil url:[athlete objectForKey:@"url"]];
    [_previousView.navigationController pushViewController:nextView animated:YES];
    [nextView setTitle:[athlete objectForKey:@"name"]];

    
}
@end
