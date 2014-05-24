//
//  MorningMailMasterViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 11/13/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//


#import "MZDayPicker.h"
#import "NSString+HTML.h"
#import "MBProgressHUD.h"
#import "MorningMailCell.h"
#import "PBWebViewController.h"
#import "UIImageView+WebCache.h"
#import "MMDrawerBarButtonItem.h"
#import "AFHTTPRequestOperation.h"
#import "MorningMailMasterViewController.h"
#import "UIViewController+MMDrawerController.h"

#define kMaxSummaryLength 300

const NSString *morningMailBaseUrl = @"http://morningmail.rpi.edu/json/";

@interface MorningMailMasterViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet MZDayPicker *dayPicker;
@property (nonatomic, strong) NSMutableArray *morningMailObjects;
@end

@implementation MorningMailMasterViewController
@synthesize master;

- (id) init {
    if (self = [super init]) {

    }
    
    return self;
}

- (NSMutableArray *) reformatMorningMailResponse:(NSDictionary *) responseObject {
    NSArray *tempReponse = [responseObject objectForKey:@"nodes"];
    NSMutableArray *reformattedArray = [NSMutableArray array];
    if(tempReponse.count == 0) {
        NSMutableDictionary *noMorningMailDict = [NSMutableDictionary dictionaryWithObject:@"No Morning Mail available for this date." forKey:@"title"];
        [noMorningMailDict setObject:[NSDictionary dictionaryWithObject:@"Morning Mail is not published on Saturday or Sunday" forKey:@"description"] forKey:@"summary_dict"];
        [reformattedArray addObject:noMorningMailDict];
    } else {
        for(int i = 0; i < tempReponse.count; ++i) {
            NSMutableDictionary *node = [[[tempReponse objectAtIndex:i] objectForKey:@"node"] mutableCopy];
            
            NSDictionary *summaryDict = [self formatSummaryForCell:[node objectForKey:@"summary"]];
            
            [node setObject:summaryDict forKey:@"summary"];
            [node setObject:[node objectForKey:@"title"] forKey:@"title"];
            [node setObject:[node objectForKey:@"link"] forKey:@"link"];

            if(node) {
                [reformattedArray addObject:node];
                [node setObject:summaryDict forKey:@"summary_dict"];
            }
        }
    }


    return reformattedArray;
}

- (void) fetchMorningMailWithDate:(NSString *) date {
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:activity]];
    [activity startAnimating];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", morningMailBaseUrl, date]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:15.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.morningMailObjects = [[NSMutableArray alloc] init];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Successfully downloaded morning mail for date
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            self.morningMailObjects = [self reformatMorningMailResponse:responseObject];
            [self.tableView reloadData];
        } else {
            NSLog(@"Response object not valid (NOT NSDictionary)");
        }
        [activity stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Failed downloading the morning mail
        NSLog(@"ERROR: error downloading morning mail: %@", error);
        [activity stopAnimating];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud setLabelText:@"Error"];
        [hud setDetailsLabelText:@"MorningMail failed to download. Please check your connection and try again."];
        [hud setMinShowTime:2.0f];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];

    }];
    
    [operation start];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:master action:@selector(show)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Morning Mail";
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    NSDate *today = [NSDate date];

    // Demo date -- uncomment
//    NSString *mmDate=[formatter stringFromDate:[NSDate dateFromDay:12 month:2 year:2014]];
    NSString *mmDate = [formatter stringFromDate:today];
    NSLog(@"DATE: %@", mmDate);
    self.dayPicker = [[MZDayPicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60) dayCellSize:CGSizeMake(24, 50) dayCellFooterHeight:10.0f];
    self.dayPicker.month = [components month];
    self.dayPicker.year = [components year];;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 10.0f;
    self.dayPicker.dayLabelFontSize = 14.0f;
    

    self.dayPicker.bottomBorderColor = [UIColor colorWithRed:0.80 green:0.17 blue:0.11 alpha:1.0];
    [self.dayPicker setActiveDaysFrom:1 toDay:[components day]];
    
    [self.dayPicker setCurrentDay:[components day] animated:YES];
    [self fetchMorningMailWithDate:mmDate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Custom formatter to handle awful formatting from morning mail JSON feed
// Sloppy implementation, eneds to be reworked in the future
- (NSDictionary *) formatSummaryForCell:(NSString *) summary {
    
    /* 3 cases: 
        1: When - Where - Summary
        2: Summary
        3: Image URL        
     */
    summary = [summary stringByRemovingNewLinesAndWhitespace];
    summary = [summary stringByConvertingHTMLToPlainText];
    summary = [summary stringByRemovingPercentEncoding];
    
    NSMutableDictionary *summaryDict = [NSMutableDictionary dictionary];
    NSString *tempDescription;
    
    // Test for case 1 (When - Where - Summary) -- Needs parsing (sloppy but no other clear choice here)
    if([[summary componentsSeparatedByString:@"Description: "] count] > 1) {
        tempDescription = [[summary componentsSeparatedByString:@"Description: "] lastObject];

        // Cut length of summary down to avoid half-page long uitableviewcells
        if ([tempDescription length] > kMaxSummaryLength) {
            NSRange range = [tempDescription rangeOfComposedCharacterSequencesForRange:(NSRange){0, kMaxSummaryLength}];
            tempDescription = [[tempDescription substringWithRange:range] stringByAppendingString:@" …"];
            
        }
        [summaryDict setObject:tempDescription forKey:@"description"];
    } else {
        if(summary) {
            // Detect image link?
            NSError *error = nil;
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];

            [detector enumerateMatchesInString:summary
                                       options:kNilOptions
                                         range:NSMakeRange(0, [summary length])
                                    usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                        [summaryDict setObject:[result URL]  forKey:@"url"];
                                    }];
            if(![summaryDict objectForKey:@"url"]) {
                [summaryDict setObject:summary forKey:@"description"];
            }

        } else {
            return nil;
        }
    }

    return summaryDict;

}
#pragma mark - Table view data source

#define PADDING 20.0f
// Auto-layout not compatible with MZDayPicker - manually coding height detection
- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.morningMailObjects.count) {
        UIFont *summaryFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        
        NSDictionary *summaryDict = [[self.morningMailObjects objectAtIndex:indexPath.row] objectForKey:@"summary_dict"];
        NSString *title = [[self.morningMailObjects objectAtIndex:indexPath.row] objectForKey:@"title" ];
        
        CGSize descriptionSize = [[summaryDict objectForKey:@"description"] sizeWithFont:summaryFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width-20.0f, 150.0f)];
        CGSize titleSize       = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width-20.0f, 44)];

        if(descriptionSize.height == 0) descriptionSize.height = 14.0f;
        return titleSize.height + descriptionSize.height + PADDING;
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.dayPicker.frame.size.height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.dayPicker;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.morningMailObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mmCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *mmNode = [self.morningMailObjects objectAtIndex:indexPath.row];
    NSDictionary *summary = [mmNode objectForKey:@"summary_dict"];
    
    NSString *title = [mmNode objectForKey:@"title"];
    title   = [title stringByRemovingPercentEncoding];
    title   = [title stringByConvertingHTMLToPlainText];
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    cell.textLabel.numberOfLines = 2;


    cell.detailTextLabel.text = ([summary objectForKey:@"description"]) ? [summary objectForKey:@"description"] : @"No article description is available at this time";
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    return cell;
}

#pragma mark - MZDayPicket delegate


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSLog(@"MONTH: %ld", (long)[components month]);
    NSString *mmMonth = [NSString stringWithFormat:@"%i", components.month];
    NSString *mmDay = [day.day stringValue];
    
    if(mmDay.length == 1) mmDay = [@"0" stringByAppendingString:mmDay];
    if(mmMonth.length == 1) mmMonth = [@"0" stringByAppendingString:mmMonth];
    NSString *mmDateString = [NSString stringWithFormat:@"%@-%@-%i", mmMonth, mmDay, components.year];
    NSLog(@"DATE SELECTED: %@", mmDateString);
 
    [self fetchMorningMailWithDate:mmDateString];
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PBWebViewController *nextView = [segue destinationViewController];
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.829 green:0.151 blue:0.086 alpha:1.000]];
    [nextView setShowsNavigationToolbar:YES];
    NSURL *url = [NSURL URLWithString:[[self.morningMailObjects objectAtIndex:self.tableView.indexPathForSelectedRow.row] objectForKey:@"link"]];
    [nextView setURL:url];
}



@end
