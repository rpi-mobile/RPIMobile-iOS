//
//  AthleticsMainViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "AthleticsMainViewController.h"
#import "AthleticsDetailViewController.h"

@interface AthleticsMainViewController ()
    @property (strong) UITableView *tableView;
    @property (strong) UISegmentedControl *genderControl;
    @property (strong) NSArray *sportsTeams;
    @property (strong) NSDictionary *sportsDic;
@end

@implementation AthleticsMainViewController
@synthesize master;

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)genderChanged:(id)sender {
    // Alphabetize keys for sports to make it easier for users to find the correct sport
    switch (_genderControl.selectedSegmentIndex) {
        case 0:
            self.sportsTeams = [[[self.sportsDic objectForKey:@"men" ] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            break;
        case 1:
            self.sportsTeams = [[[self.sportsDic objectForKey:@"women" ] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void) buildView {
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 30)];
    
    self.genderControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"male.png"],[UIImage imageNamed:@"female.png"]]];
    self.genderControl.tintColor = [UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000];
    self.genderControl.frame = CGRectMake(5, 0, 310, 29);
    [background addSubview:self.genderControl];
    
    [self.genderControl addTarget:self action:@selector(genderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.genderControl setSelectedSegmentIndex:0];
    [self genderChanged:self.genderControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 29, self.view.frame.size.width, self.view.frame.size.height-29) style:UITableViewStyleGrouped];//CGRectMake(0, 29, self.view.frame.size.width, self.view.frame.size.height-29) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];

    [self.view addSubview:self.tableView];
    //[self.tableView addSubview:self.genderControl];
    //[self.tableView bringSubviewToFront:self.genderControl];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:background];
    [self.view bringSubviewToFront:background];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.829 green:0.151 blue:0.086 alpha:1.000]];
    background.backgroundColor = _tableView.backgroundColor;
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:master action:@selector(show)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Athletics";

    // Read sports lists into dictionaries from plist files (allows for remote updating of resources)
    NSDictionary *_menSports = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menSportsList" ofType:@"plist"]];
    NSDictionary *_womenSports = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"womenSportsList" ofType:@"plist"]];

    _sportsDic = [[NSDictionary alloc] initWithObjects:@[_menSports, _womenSports] forKeys:@[@"men", @"women"]];
    [self.tableView setRowHeight:60.0f];
    [self buildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:  (NSInteger)section {
    return self.genderControl;
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (_genderControl.selectedSegmentIndex == 0) ? @"Men's Teams" : @"Women's Teams";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _sportsTeams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_sportsTeams objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *currentGender = (_genderControl.selectedSegmentIndex == 1) ? @"women" : @"men";
    NSString *nextViewSport = [_sportsTeams objectAtIndex:indexPath.row];
    NSString *nextViewKey = [[_sportsDic objectForKey:currentGender] objectForKey:nextViewSport];
    
    AthleticsDetailViewController *nextView = [[AthleticsDetailViewController alloc] initWithSport:nextViewSport gender:currentGender key:nextViewKey];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
