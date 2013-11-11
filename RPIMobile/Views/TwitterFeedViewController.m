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
#import "TwitterFeedViewController.h"

#define kTwitterFeedListID @"75671359"
#define kTwitterConsumerKey @"zCx2p9ktPO4r5jpLC0fyEw"
#define kTwitterConsumerSecret @"jincrPpRGq6SHO85ZjW5OcMw75XsRnxRqaKYP1dBWR0"


@interface TwitterFeedViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSString *latestTweetID;
@end

@implementation TwitterFeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        // ^-Use UITextAlignmentCenter for older SDKs.
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"Twitter Feeds", @"");
        [label sizeToFit];
    }
    return self;
}
- (void)fetchTweets {

    [self.twitter getListsStatusesForListID:kTwitterFeedListID sinceID:self.latestTweetID maxID:nil count:@"50" includeEntities:nil includeRetweets:[NSNumber numberWithInt:1] successBlock:^(NSArray *statuses) {
        // Downloaded tweets from RPIMobileApp list
        NSLog(@"Successfully downloaded %i tweets.", statuses.count);
        
        if (statuses && statuses.count > 0) {
            self.latestTweetID = [[statuses firstObject] objectForKey:@"id"];
            NSLog(@"Updating latest tweet ID to %@", self.latestTweetID);
            NSLog(@"status: %@", [statuses firstObject]);
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

- (void)viewDidLoad
{
    self.latestTweetID = nil;
    
    [super viewDidLoad];
    [self authenticateTwitter];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    // Refresh controls for UITableView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tweets.count;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (TweetCell *)[TweetCell cellFromNibNamed:@"TweetCell"];
    }
    
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


@end
