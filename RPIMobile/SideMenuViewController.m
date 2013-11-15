//
//  SideMenuViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 6/9/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "MMTableViewCell.h"
#import "MMDrawerBarButtonItem.h"
#import "DataSources.h"
#import "AFHTTPRequestOperation.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "MMSideDrawerTableViewCell.h"
#import "SideMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CRNavigationController.h"
#import "UIImage+Tint.h"

#import "NewsFeedViewController.h"
#import "AthleticsMainViewController.h"
#import "TwitterFeedViewController.h"
#import "LaundryViewController.h"
#import "DirectoryMasterViewController.h"

#define kWeatherRefreshInterval 0 // In seconds (10 minutes)
#define kWeatherBarHeight 44

@interface SideMenuViewController ()
@property (strong) NSArray *menuItems;
@property (nonatomic, strong) UITableView * tableView;
@property (strong) NSMutableDictionary *weatherInfo;
@property (strong) NSDate *weatherLastUpdated;
@end

@implementation SideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *) convertKelvinToFahrenheit:(CGFloat) kelvin {
    return [NSString stringWithFormat:@"%0.1f", ((kelvin - 273) * 1.8 ) + 32];
}

// Using openweathermap API, fetches JSON object of troy, ny weather
- (void) fetchWeatherStatus {
    NSURL *url = [NSURL URLWithString:kWeatherStatusUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Successfully downloaded updated weather information
        self.weatherInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        if([self.weatherInfo objectForKey:@"main"]) {
            // Convert kelvin temp
            CGFloat kelvin = [[[self.weatherInfo objectForKey:@"main"] objectForKey:@"temp"] floatValue];
            NSString *fahrenheit = [self convertKelvinToFahrenheit:kelvin];
            [self.weatherInfo setValue:fahrenheit forKey:@"current_temp"];

            UIView *v = [[self tableView] tableHeaderView];
            NSLog(@"%@", [v subviews]);
            [[[v subviews] firstObject] setText: @"Test"];
            
        } else {
            NSLog(@"Error: Invalid return object when fetching weather!");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Error downloading weather information
        NSLog(@"Error downloading weather: %@", error);
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];
    }
    
    [super viewDidLoad];
    [self fetchWeatherStatus];
    
    _menuItems = [[NSArray alloc] initWithObjects: @[@"Athletics", @"trophy.png"] ,
                                                   @[@"Laundry", @"flag.png"],
                                                   @[@"Social Feed", @"twitter.png"],
                                                   @[@"Directory", @"group.png"],
                                                   @[@"MorningMail", @"envelope.png"],
                                                   @[@"News Feed", @"book.png"],
                                                   nil];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void) viewDidAppear:(BOOL)animated {
    [self fetchWeatherStatus];
    if(!self.weatherLastUpdated) self.weatherLastUpdated = [NSDate date];
    if( ([self.weatherLastUpdated timeIntervalSinceNow]) > kWeatherRefreshInterval) {
        // Need to update weather
        NSLog(@"Weather needs to be udpated");
        [self fetchWeatherStatus];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSArray *menuItem = [_menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [menuItem firstObject];
    cell.imageView.image = [[UIImage imageNamed:[menuItem lastObject]] imageTintedWithColor:[UIColor colorWithWhite:0.402 alpha:1.000]];

    return cell;
}

- (void) toggleWeatherView:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *weatherView = gestureRecognizer.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    
    CGRect newHeaderFrame = weatherView.frame;
    newHeaderFrame.size.height = (weatherView.frame.size.height > kWeatherBarHeight) ? newHeaderFrame.size.height - 100.0f : newHeaderFrame.size.height + 100.0f;
    [weatherView setFrame:newHeaderFrame];
    
    [UIView commitAnimations];
    

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *weatherView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.bounds), kWeatherBarHeight)];
    [weatherView setBackgroundColor:[UIColor colorWithWhite:0.333 alpha:0.900]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleWeatherView:)];
    [weatherView addGestureRecognizer:singleTap];
    CGRect w = weatherView.frame;
    w.origin.y = kWeatherBarHeight/2;
    w.size.height = kWeatherBarHeight/2;
    
    
    NSString *weatherString = ([self.weatherInfo objectForKey:@"current_temp"]) ? [NSString stringWithFormat:@"Current Weather: %@°F", [self.weatherInfo objectForKey:@"current_temp"]] : @"Main Menu";
    UILabel *weatherLabel = [[UILabel alloc] initWithFrame:w];
    [weatherLabel setText:weatherString];
    [weatherLabel setTextColor:[UIColor whiteColor]];
    [weatherLabel setFont:[UIFont systemFontOfSize:14]];
    
    [weatherView addSubview:weatherLabel];
    [weatherView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    return weatherView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWeatherBarHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *nextView;
    UIStoryboard *storyboard;
    switch (indexPath.row) {
        case 0:
            nextView = [[AthleticsMainViewController alloc] init];
            break;
        case 1:
            storyboard = [UIStoryboard storyboardWithName:@"LaundryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
            break;
        case 2:
            storyboard = [UIStoryboard storyboardWithName:@"TwitterStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
            break;
        case 3:
            storyboard = [UIStoryboard storyboardWithName:@"DirectoryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
            break;
        case 4:
            storyboard = [UIStoryboard storyboardWithName:@"MorningMailStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
            break;
        case 5:
            nextView = [[NewsFeedViewController alloc] init];
            break;
        default:
            break;
    }
    
    CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:nextView];
    [nav.navigationBar setBarTintColor:[UIColor redColor]];
    
    [self.mm_drawerController setCenterViewController:nav withFullCloseAnimation:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
