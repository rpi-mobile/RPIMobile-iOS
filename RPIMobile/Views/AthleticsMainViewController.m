//
//  AthleticsMainViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "AthleticsMainViewController.h"
#import "AthleticsDetailViewController.h"

#define kGenderControlHeight 35

@interface AthleticsMainViewController ()
    @property (strong) UITableView *tableView;
    @property (strong) UISegmentedControl *genderControl;
    @property (strong) NSArray *sportsTeams;
    @property (strong) NSDictionary *sportsDic;
@end

@implementation AthleticsMainViewController

- (id)init {
    if (self = [super init]) {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        // ^-Use UITextAlignmentCenter for older SDKs.
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"RPI Athletics", @"");
        [label sizeToFit];
    }
    return self;
}

- (void)genderChanged:(id)sender {
    switch (_genderControl.selectedSegmentIndex) {
        case 0:
            _sportsTeams = [[_sportsDic objectForKey:@"men" ] allKeys];
            break;
        case 1:
            _sportsTeams = [[_sportsDic objectForKey:@"women" ] allKeys];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void) buildView {

    _genderControl = [[UISegmentedControl alloc] initWithItems:@[@"Men", @"Women"]];
    _genderControl.frame = CGRectMake(-5, 64, self.view.frame.size.width + 10, kGenderControlHeight);
    _genderControl.tintColor = [UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000];
    _genderControl.backgroundColor = [UIColor whiteColor];
    _genderControl.alpha = 0.85f;
    
    [_genderControl addTarget:self action:@selector(genderChanged:) forControlEvents:UIControlEventValueChanged];
    [_genderControl setSelectedSegmentIndex:0];
    [self genderChanged:_genderControl];

    // Compensate for _genderControl height under UINavigationBar
//    viewFrame.origin.y += kGenderControlHeight;
//    viewFrame.size.height -= kGenderControlHeight;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.contentInset = UIEdgeInsetsMake(kGenderControlHeight,0,0,0);
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_genderControl];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000]];
}

//- (CGFloat)topOfViewOffset
//{
//    CGFloat top = 0;
//    if ([self respondsToSelector:@selector(topLayoutGuide)])
//    {
//        top = self.topLayoutGuide.length;
//    }
//    return top;
//}
//
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    self.genderControl.frame = CGRectMake(-10, self.topOfViewOffset, self.view.frame.size.width + 20, 35);
//}

- (void)viewDidLoad
{
    // Sets view to start below UINavigationBar
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
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
