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
#import "AthleticsNewsTableViewCell.h"
#import "AthleticsNewsViewController.h"

@interface AthleticsNewsViewController () <MWFeedParserDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MWFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *feedItems;
//@property (nonatomic, strong) UIViewController *previousView; // Could be done better! FUTURE

@end

@implementation AthleticsNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseNewFeed:self.key];
    [self.tableView setRowHeight:200.0f];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"athleticNewsCell";
    AthleticsNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AthleticsNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MWFeedItem *item = [self.feedItems objectAtIndex:indexPath.row];
    NSString *title = item.title ? item.title : @"[No Title]";
    NSURL *imageUrl;
    for(NSDictionary *enclosure in item.enclosures) {
        if([[enclosure objectForKey:@"type"] isEqualToString:@"image/jpg"]) {
            imageUrl = [NSURL URLWithString:[enclosure objectForKey:@"url"]];
            NSLog(@"Enclosure: %@", enclosure);
            break;
        }
    }
    [cell.articleImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"blank_news_image.png"]];
    cell.clipsToBounds = YES;
    cell.articleTitle.text = title;

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Test: %@", self.parentViewController.navigationController);

    MWFeedItem *item = [_feedItems objectAtIndex:indexPath.row];
    
    // Make sure the RSS item has a link
    if (item.link) {
        PBWebViewController *nextView = [[PBWebViewController alloc] init];// initWithNibName:@"WebViewController" bundle:nil url:item.link];
        [nextView setURL:[NSURL URLWithString:item.link]];
        [self.previousView.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.829 green:0.151 blue:0.086 alpha:1.000]];
        [nextView setShowsNavigationToolbar:YES];
        [self.previousView.navigationController pushViewController:nextView animated:YES];
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
    // FUTURE: add error message details here with MBProgressHUD
    NSLog(@"Error Parsing: %@", error);
}


@end
