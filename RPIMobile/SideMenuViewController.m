//
//  SideMenuViewController.m
//  NYEpsilon
//
//  Created by Stephen Silber on 6/9/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "MMDrawerBarButtonItem.h"

#import "MenuItemCell.h"
#import "DataSources.h"
#import "AFHTTPRequestOperation.h"

#import "SideMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CRNavigationController.h"
#import "UIImage+Tint.h"

#import "NewsFeedViewController.h"
#import "AthleticsMainViewController.h"
#import "TwitterFeedViewController.h"
#import "LaundryViewController.h"
#import "DirectoryMasterViewController.h"
#import "CampusMapViewController.h"

@interface SideMenuViewController () {
    NSArray *menuItems;
}

@property (nonatomic, strong) IBOutlet UITableView * tableView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    menuItems = @[@"Athletics", @"Social\nFeed", @"Campus Map", @"Laundry", @"Morning\nMail", @"Directory", @"Settings"];
}

- (void) viewDidAppear:(BOOL)animated {

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell"];
    
    switch (indexPath.row) {
        case 0:
            // Athletics
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"trophy"];
            break;
        case 1:
            // Social Feed
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"twitter"];
            break;
        case 2:
            // Campus Map
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"location"];
            break;
        case 3:
            // Laundry
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"time"];
            break;
        case 4:
            // Morning Mail
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"envelope"];
            break;
        case 5:
            // Directory
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"group"];
            break;
        case 6:
            // Settings
            cell.itemTitle.text = [menuItems objectAtIndex:indexPath.row];
            cell.itemIconView.image = [UIImage imageNamed:@"cog"];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *nextView;
    CRNavigationController *navController;
    UIStoryboard *storyboard;
    switch (indexPath.row) {
        case 0:
            nextView = [[AthleticsMainViewController alloc] init];
             navController = [[CRNavigationController alloc] initWithRootViewController:nextView];
            [self.mm_drawerController setCenterViewController:navController withCloseAnimation:YES completion:nil];
            return;
        case 1:
            storyboard = [UIStoryboard storyboardWithName:@"TwitterStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withCloseAnimation:YES completion:nil];
            return;
        case 2:
            storyboard = [UIStoryboard storyboardWithName:@"CampusMapViewController" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withCloseAnimation:YES completion:nil];
            return;
        case 3:
            storyboard = [UIStoryboard storyboardWithName:@"LaundryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withCloseAnimation:YES completion:nil];
            return;
        case 4:
            storyboard = [UIStoryboard storyboardWithName:@"MorningMailStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withCloseAnimation:YES completion:nil];
            return;
        case 5:
            storyboard = [UIStoryboard storyboardWithName:@"DirectoryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withCloseAnimation:YES completion:nil];
            return;
        default:
            return;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
