//
//  TwitterFeedViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 11/7/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "Base64.h"
#import "TweetCell.h"
#import "STTwitter.h"
#import "TweetCell.h"
#import "UIImageView+WebCache.h"
#import "MMDrawerBarButtonItem.h"
#import "TwitterFeedViewController.h"
#import "UIViewController+MMDrawerController.h"

#define kLoadingCellTag 999
#define kTwitterFeedListID @"75671359"
#define kTwitterConsumerKey @"zCx2p9ktPO4r5jpLC0fyEw"
#define kTwitterConsumerSecret @"jincrPpRGq6SHO85ZjW5OcMw75XsRnxRqaKYP1dBWR0"


@interface TwitterFeedViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSString *latestTweetId, *oldestTweetId;
@end

@implementation TwitterFeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        // this will appear as the title in the navigation bar
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont systemFontOfSize:20.0];
//        label.textAlignment = NSTextAlignmentCenter;
//        
//        // ^-Use UITextAlignmentCenter for older SDKs.
//        label.textColor = [UIColor whiteColor];
//        self.navigationItem.titleView = label;
//        label.text = NSLocalizedString(@"Twitter Feeds", @"");
//        [label sizeToFit];
    }
    return self;
}

- (void) loadMoreTweets {
    if(self.tweets && self.tweets.count > 0) {
        double oldestId = [[[self.tweets lastObject] objectForKey:@"id"] doubleValue] - 50;
        
        self.oldestTweetId = [NSString stringWithFormat:@"%.0f", oldestId];
        NSLog(@"Updating oldest tweet ID to %@ %.0f", self.oldestTweetId, oldestId);
        
        [self.twitter getListsStatusesForListID:kTwitterFeedListID sinceID:nil maxID:self.oldestTweetId count:@"50" includeEntities:nil includeRetweets:[NSNumber numberWithInt:1] successBlock:^(NSArray *statuses) {

            [self.tweets addObjectsFromArray:statuses];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        } errorBlock:^(NSError *error) {
            // ...
            NSLog(@"ERROR: Failed to download tweets: %@", error);
        }];

    } else {
        [self fetchTweets];
    }
}

- (void)fetchTweets {

    [self.twitter getListsStatusesForListID:kTwitterFeedListID sinceID:self.latestTweetId maxID:nil count:@"50" includeEntities:nil includeRetweets:[NSNumber numberWithInt:1] successBlock:^(NSArray *statuses) {
        // Downloaded tweets from RPIMobileApp list
        NSLog(@"Successfully downloaded %i tweets.", statuses.count);
        
        if (statuses && statuses.count > 0) {
            self.latestTweetId = [[statuses firstObject] objectForKey:@"id"];
            NSLog(@"Updating newest tweet ID to %@", self.latestTweetId);
        }
        
        if (!self.tweets) {
            self.tweets = [NSMutableArray array];
        }
        
        [self.tweets addObjectsFromArray:statuses];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    } errorBlock:^(NSError *error) {
        // ...
        NSLog(@"ERROR: Failed to download tweets: %@", error);
    }];
}

- (void) authenticateTwitter {

    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey: kTwitterConsumerKey
                                                            consumerSecret:kTwitterConsumerSecret];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [self fetchTweets];
    } errorBlock:^(NSError *error) {
        // ...
        NSLog(@"ERROR: Failed when verifying twitter credentials: %@", error);
    }];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [self authenticateTwitter];
    
    [super viewDidLoad];
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    // Refresh controls for UITableView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView setScrollsToTop:YES];
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
    return self.tweets.count + 1;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tweetCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tweetCell";
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.tweet.text = [tweet objectForKey:@"text"];
    cell.username.text = [NSString stringWithFormat:@"@%@", [[tweet objectForKey:@"user"] objectForKey:@"screen_name" ]];
    cell.date.text = [self timeSinceTweetTimestamp:[tweet objectForKey:@"created_at"]];

    // Get the Layer of any view
    CALayer * l = [cell.profileImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:30.0];
    [l setBorderWidth:0.25f];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    // Grab old profile image url and fetch higher quality image
    NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
    [cell.profileImage setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    return cell;
    
}

- (NSString *) timeSinceTweetTimestamp:(NSString *) timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *startingDate = [dateFormatter dateFromString:timestamp];
    NSDate *endingDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startingDate toDate:endingDate options:0];
    
    NSInteger days     = [dateComponents day];
    NSInteger months   = [dateComponents month];
    NSInteger years    = [dateComponents year];
    NSInteger hours    = [dateComponents hour];
    NSInteger minutes  = [dateComponents minute];
    NSInteger seconds  = [dateComponents second];
    
    // Format string for small time interval on TweetCell
    NSString *formattedString;
    
    if(months > 12) {
        formattedString = [NSString stringWithFormat:@"%iy", years];
    } else if(months > 0) {
        formattedString = [NSString stringWithFormat:@"%iM", months];
    } else if(days > 0) {
        formattedString = [NSString stringWithFormat:@"%id", days];
    } else if(hours > 0) {
        formattedString = [NSString stringWithFormat:@"%ih", hours];
    } else if(minutes > 0) {
        formattedString = [NSString stringWithFormat:@"%im", minutes];
    } else {
        formattedString = [NSString stringWithFormat:@"%is", seconds];
    }
    
    return formattedString;
}

#define PADDING 10.0f

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.tweets.count) {
        NSString *text = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 90, 1000.0f)];
        return textSize.height + 50;
    }

    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row < self.tweets.count) ? [self tweetCellForRowAtIndexPath:indexPath] : [self loadingCell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag && self.tweets) {
        [self loadMoreTweets];
    }
    
    if(indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end
