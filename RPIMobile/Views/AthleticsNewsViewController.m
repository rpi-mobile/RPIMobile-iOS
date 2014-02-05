//
//  AthleticsNewsViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/1/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "DataSources.h"
#import "MBProgressHUD.h"
#import "NewsFeedCell.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"
#import "PBWebViewController.h"
#import "AthleticsNewsViewController.h"

@interface AthleticsNewsViewController () <UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate>

@property (strong) UITableView *tableView;
@property (strong) MWFeedParser *feedParser;
@property (strong) NSMutableArray *feedItems;
@property (strong) UIViewController *previousView; // Is this the proper way to handle this case?

@end

@implementation AthleticsNewsViewController

- (id)initWithSport:(NSString *) sport andKey:(NSString *) key andViewController:(UIViewController *)view
{
    if (self = [super init]) {
        _previousView = view; // Used to push news articles onto navigation stack of previous view
        [self parseNewFeed:key];
    }
    return self;
}

- (void)viewDidLoad
{
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Build table view
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [super viewDidLoad];
    [self.view addSubview:_tableView];

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

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rawSummary = [[[_feedItems objectAtIndex:indexPath.row] summary] stringByConvertingHTMLToPlainText];
    NSString *rawTitle = [[[_feedItems objectAtIndex:indexPath.row] title] stringByConvertingHTMLToPlainText];
    NSAttributedString *summary = [[NSAttributedString alloc] initWithString:rawSummary];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:rawTitle];

    CGFloat titleHeight = [self textViewHeightForAttributedText:title andWidth:self.view.frame.size.width];
    CGFloat cellHeight = [self textViewHeightForAttributedText:summary andWidth:tableView.frame.size.width - 40];

    // Clean this up to be more efficient/accurate
    return (cellHeight > 0) ? (cellHeight + titleHeight + 10) : 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MWFeedItem *item = [_feedItems objectAtIndex:indexPath.row];
    NSString *title = item.title ? item.title : @"[No Title]";
    NSString *summary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
    
    cell.textLabel.text = title;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    cell.detailTextLabel.text = summary;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MWFeedItem *item = [_feedItems objectAtIndex:indexPath.row];
    
    // Make sure the RSS item has a link
    if (item.link) {
        PBWebViewController *nextView = [[PBWebViewController alloc] init];// initWithNibName:@"WebViewController" bundle:nil url:item.link];
        [nextView setURL:[NSURL URLWithString:item.link]];
        [_previousView.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.829 green:0.151 blue:0.086 alpha:1.000]];
        [nextView setShowsNavigationToolbar:YES];
        [_previousView.navigationController pushViewController:nextView animated:YES];
    }

}

#pragma mark -
#pragma mark HorizMenu Delegate

-(void) parseNewFeed:(NSString *) key {
    NSURL *feedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAthleticsFeedUrl, key]];
    NSLog(@"Parser called with URL: %@", feedUrl);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _feedParser = [[MWFeedParser alloc] initWithFeedURL:feedUrl];
    _feedParser.delegate = self;
    _feedParser.feedParseType = ParseTypeFull;
    _feedParser.connectionType = ConnectionTypeAsynchronously;
    
    [_feedParser parse];
    
}

#pragma mark - Feed parser delegate calls

// Called when data has downloaded and parsing has begun
- (void)feedParserDidStart:(MWFeedParser *)parser {
    _feedItems = [NSMutableArray array];

}

// Provides info about the feed
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}

// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    [_feedItems addObject:item];
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
}

// Parsing failed
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Error Parsing: %@", error);
}


@end
