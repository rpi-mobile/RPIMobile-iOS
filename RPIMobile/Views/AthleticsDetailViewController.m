//
//  AthleticsDetailViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/30/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//
#import "WebViewController.h"
#import "ViewPagerController.h"
#import "AthleticsDetailViewController.h"
#import "AthleticsRosterViewController.h"
#import "AthleticsNewsViewController.h"
#import "AthleticsScheduleViewController.h"

#define kMenuItems @[@"News", @"Roster", @"Schedule", @"Mobile Site"]

@interface AthleticsDetailViewController () <ViewPagerDelegate, ViewPagerDataSource>
    @property (strong) NSString *key;
    @property (strong) NSString *gender;
    @property (strong) NSString *sport;
@end

@implementation AthleticsDetailViewController

- (id)initWithSport:(NSString *) sport gender:(NSString *) gender key:(NSString *)key {
    if (self = [super init]) {
        _key = key;
        _sport = sport;
        _gender = gender;
    }
    return self;
}

- (void)viewDidLoad
{
    // FUTURE: Setup custom background view that can be seen when dragging past first and last sections
    self.title = self.sport;
    self.dataSource = self;
    self.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.kDefaultTabWidth = [NSNumber numberWithFloat:self.view.frame.size.width/3];

    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    switch (index) {
        case 0:
            label.text = @"News";
            break;
        case 1:
            label.text = @"Roster";
            break;
        case 2:
            label.text = @"Schedule";
            break;
        default:
            label.text = @"";
            break;
    }
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {

    UIViewController *nextView;
    AthleticsNewsViewController *newsView;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AthleticsStoryboard_iPhone" bundle:nil];
    switch (index) {
        case 0:
            // News tab requested
            newsView = [sb instantiateViewControllerWithIdentifier:@"newsView"];
            newsView.key = self.key;
            newsView.sport = self.sport;
            newsView.previousView = self;
            return newsView;
            break;
        case 1:
            // Roster tab requested
            nextView = [[AthleticsRosterViewController alloc] initWithSport:self.sport andKey:self.key andGender:self.gender andViewController:self];
            break;
        case 2:
            // Schedule tab requested
            nextView = [[AthleticsScheduleViewController alloc] initWithSport:self.sport andKey:self.key andGender:self.gender];
            break;
        default:
            break;
    }
    return nextView;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor redColor];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
}


@end
