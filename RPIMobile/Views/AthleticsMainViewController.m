//
//  AthleticsMainViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "AthleticsMainViewController.h"
#import "AthleticsDetailViewController.h"

// Sports list for each gender at RPI
#define kMensSports @[@"Baseball",@"Basketball",@"Cross Country",@"Football",@"Golf",@"Hockey",@"Indoor Track",@"Lacrosse",@"Soccer",@"Swimming & Diving",@"Tennis",@"Track and Field"]
#define kWomensSports @[@"Basketball",@"Cross Country",@"Field Hockey",@"Ice Hockey",@"Indoor Track",@"Lacrosse",@"Soccer",@"Softball",@"Swimming & Diving",@"Tennis",@"Track and Field"]
#define kGenderControlHeight 35

@interface AthleticsMainViewController ()
    @property (strong) UITableView *tableView;
    @property (strong) UISegmentedControl *genderControl;
    @property (strong) NSArray *sportsTeams;

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
            _sportsTeams = kMensSports;
            break;
        case 1:
            _sportsTeams = kWomensSports;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void) buildView {

    _genderControl = [[UISegmentedControl alloc] initWithItems:@[@"Men", @"Women"]];
    _genderControl.frame = CGRectMake(-5, 0, self.view.frame.size.width + 10, kGenderControlHeight);
    _genderControl.tintColor = [UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000];
    _genderControl.backgroundColor = [UIColor whiteColor];
    
    [_genderControl addTarget:self action:@selector(genderChanged:) forControlEvents:UIControlEventValueChanged];
    [_genderControl setSelectedSegmentIndex:0];
    [self genderChanged:_genderControl];

    // Compensate for _genderControl height under UINavigationBar
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += kGenderControlHeight;
    viewFrame.size.height -= kGenderControlHeight;
    
    _tableView = [[UITableView alloc] initWithFrame:viewFrame style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_genderControl];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets view to start below UINavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    NSString *currentGender = @"male";
    if (_genderControl.selectedSegmentIndex == 1) currentGender = @"female";
    
    AthleticsDetailViewController *nextView = [[AthleticsDetailViewController alloc] initWithSport:[_sportsTeams objectAtIndex:indexPath.row] gender:currentGender];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
