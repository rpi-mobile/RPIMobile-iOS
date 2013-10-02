//
//  NewsFeedViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "REMenu.h"
#import "NSString+HTML.h"
#import "NewsFeedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>



// Move these to a header file
#define newsFeedAll @"feed://news.rpi.edu/rss.xml"
#define newsFeedAcademics @"http://www.rpi.edu/news/rss/academics.xml"
#define newsFeedFaculty @"http://www.rpi.edu/news/rss/faculty.xml"
#define newsFeedResearch @"http://www.rpi.edu/news/rss/research.xml"
#define newsFeedArts @"http://www.rpi.edu/news/rss/arts.xml"
#define newsFeedCommunity @"http://www.rpi.edu/news/rss/community.xml"
#define newsFeedCalendar @"http://www.rpi.edu/dept/cct/apps/oth/data/rpiTodaysEvents.rss"
#define newsFeedAthletics @"http://www.rpiathletics.com/rss.aspx"
#define newsFeedPoly @"http://poly.rpi.edu/?feed=atom"
#define newsFeedMorningMail @"http://morningmail.rpi.edu/rss"
@interface NewsFeedViewController ()
    @property (strong) MWFeedParser *feedParser;
    @property (strong, readwrite, nonatomic) REMenu *menu;
    @property (strong) NSMutableArray *feedItems;
@end

@implementation NewsFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        // ^-Use UITextAlignmentCenter for older SDKs.
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"News Feed", @"");
        [label sizeToFit];
    }
    return self;
}

- (void) buildView {
    
    // Table view configuration
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Feeds" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu)];

    [menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = menuButton;
    

    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"All"
                                                    subtitle:nil
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self parseNewFeed:@"All"];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Morning Mail"
                                                       subtitle:nil
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self parseNewFeed:@"MorningMail"];
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"The Poly"
                                                        subtitle:nil
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                             [self parseNewFeed:@"Poly"];
                                                          }];
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem]];
    
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.828 green:0.000 blue:0.000 alpha:1.000]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"News Feed"];
    
    [self buildView];
    [self parseNewFeed:@"All"];
    
}

#pragma mark -
#pragma mark REMenu Data Source

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}

#pragma mark -
#pragma mark HorizMenu Delegate

-(void) parseNewFeed:(NSString *) key {
    NSDictionary *feedUrls = [NSDictionary dictionaryWithObjectsAndKeys:newsFeedAll, @"All",
                              newsFeedAcademics, @"Academics", newsFeedFaculty, @"Faculty",
                              newsFeedResearch, @"Research", newsFeedArts, @"Arts",
                              newsFeedCommunity, @"Community", newsFeedCalendar, @"Calendar",
                              newsFeedAthletics, @"Athletics", newsFeedPoly, @"Poly",
                              newsFeedMorningMail, @"MorningMail", nil];
    
    NSURL *feedUrl = [NSURL URLWithString:[feedUrls objectForKey:key]];
    
    _feedParser = [[MWFeedParser alloc] initWithFeedURL:feedUrl];
    _feedParser.delegate = self;
    _feedParser.feedParseType = ParseTypeFull;
    _feedParser.connectionType = ConnectionTypeAsynchronously;
    
    [_feedParser parse];
    
}

#pragma mark - Feed parser delegate calls
/*
 NSString *title = item.title ? item.title : @"[No Title]";
 NSString *link = item.link ? item.link : @"[No Link]";
 NSString *summary = item.summary ? item.summary : @"[No Summary]";
 */
// Called when data has downloaded and parsing has begun
- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Parsing started: %@", parser.url);
    _feedItems = [NSMutableArray array];
}

// Provides info about the feed
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}

// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Item added: %@ - %@", item.title, item.summary);
    [_feedItems addObject:item];
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [self.tableView reloadData];
}

// Parsing failed
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
//    [[self navigationItem] setRightBarButtonItem:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    MWFeedItem *item = [_feedItems objectAtIndex:indexPath.row];
    
    NSString *title = item.title ? item.title : @"[No Title]";
//    NSString *link = item.link ? item.link : @"[No Link]";
    NSString *summary = [item.summary stringByConvertingHTMLToPlainText] ? item.summary : @"[No Summary]";
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = summary;
    
    return cell;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rawSummary = [[[_feedItems objectAtIndex:indexPath.row] summary] stringByConvertingHTMLToPlainText];
    NSAttributedString *summary = [[NSAttributedString alloc] initWithString:rawSummary];

    CGFloat cellHeight = [self textViewHeightForAttributedText:summary andWidth:tableView.frame.size.width];
    return (cellHeight > 0) ? cellHeight : 100;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
