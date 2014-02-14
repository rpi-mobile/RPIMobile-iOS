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

@interface SideMenuViewController ()
@property (strong) NSArray *menuItems;
@property (nonatomic, strong) UITableView * tableView;

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
    
    // Temporary solution -- doesn't really fix the tableview when scrolling. Suggested to switch to tableview inside of UIViewController
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
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
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
        case 1:
            storyboard = [UIStoryboard storyboardWithName:@"TwitterStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
        case 3:
            storyboard = [UIStoryboard storyboardWithName:@"LaundryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
        case 4:
            storyboard = [UIStoryboard storyboardWithName:@"MorningMailStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
            return;
        case 5:
            storyboard = [UIStoryboard storyboardWithName:@"DirectoryStoryboard_iPhone" bundle:nil];
            nextView = [storyboard instantiateInitialViewController];
            [self.mm_drawerController setCenterViewController:nextView withFullCloseAnimation:YES completion:nil];
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
