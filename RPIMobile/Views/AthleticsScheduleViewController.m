//
//  AthleticsScheduleViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "JSONKit.h"
#import "DataSources.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSString+HTML.h"
#import "AFHTTPRequestOperation.h"
#import "AthleticsScheduleViewController.h"

@interface AthleticsScheduleViewController () <UITableViewDataSource, UITableViewDelegate>
    @property (strong) UITableView *tableView;
    @property (strong) NSArray *schedule;
    @property (strong) NSString *key, *sport, *gender;
@end

@implementation AthleticsScheduleViewController

// Custom initializer to pass information from parent view
- (id) initWithSport:(NSString *)sport andKey:(NSString *)key andGender:(NSString *)gender
{
    if (self = [super init]) {
        _sport = sport;
        _gender = gender;
        _key = key;
    }
    return self;
}

- (void) downloadSchedule {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAthleticsScheduleUrl, _key]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Finished download of %@ objects", responseObject);
        _schedule = [responseObject objectForKey:@"events"];
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
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self downloadSchedule];
    
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
    return _schedule.count;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

#define kPadding 85
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rawTeam = [[[_schedule objectAtIndex:indexPath.row] objectForKey:@"team"] stringByRemovingNewLinesAndWhitespace];
    NSAttributedString *team = [[NSAttributedString alloc] initWithString:rawTeam];
    
    CGFloat titleHeight = [self textViewHeightForAttributedText:team andWidth:self.view.frame.size.width - 250.0f];
    return titleHeight + kPadding;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *event = [_schedule objectAtIndex:indexPath.row];

    NSString *opponent = [event objectForKey:@"team"] ? [[event objectForKey:@"team"] stringByRemovingNewLinesAndWhitespace] : @"[No Team]";
    // What is going on here:
    NSString *score = [event objectForKey:@"score"] ? @"[No Score]" : [event objectForKey:@"score"];
    NSString *date = [event objectForKey:@"date"] ? [[event objectForKey:@"date"] stringByRemovingNewLinesAndWhitespace] : @"[No Date]";
    NSString *time = [event objectForKey:@"time"] ? [[event objectForKey:@"time"] stringByRemovingNewLinesAndWhitespace] : @"[No Time]";
    NSString *location = [event objectForKey:@"location"] ? [[event objectForKey:@"location"] stringByRemovingNewLinesAndWhitespace] : @"[No Location]";
    
    cell.textLabel.text = [event objectForKey:@"team"];
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Opponent: %@\nLocation: %@\nDate: %@\nTime: %@\nScore: %@", opponent, location, date, time, score];
    cell.detailTextLabel.numberOfLines = 0;

    
    
    [cell.imageView setImageWithURL:[event objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"date_placeholder.png"]];

    
    // Get the Layer of any view
    CALayer * l = [cell.imageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0];
    
    return cell;
}

@end
