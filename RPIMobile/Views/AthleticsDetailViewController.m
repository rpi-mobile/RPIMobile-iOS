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
    @property (strong) NSString *key, *sport, *gender;
@end

@implementation AthleticsDetailViewController

- (id)initWithSport:(NSString *) sport gender:(NSString *) gender key:(NSString *)key {
    if (self = [super init]) {
        _key = key;
        _sport = sport;
        _gender = gender;

        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        // ^-Use UITextAlignmentCenter for older SDKs.
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(sport, @"");
        [label sizeToFit];

    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.dataSource = self;
    self.delegate = self;
//    self.view.contentMode = UIEdgeInsetsMake(64,0,0,0);

    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
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
    switch (index) {
        case 0:
            // News tab tapped
            nextView = [[AthleticsNewsViewController alloc] initWithSport:_sport andKey:_key andViewController:self];
            break;
        case 1:
            // Roster tab tapped
            nextView = [[AthleticsRosterViewController alloc] initWithSport:_sport andKey:_key andGender:_gender andViewController:self];
            break;
        case 2:
            // Schedule tab tapped
            nextView = [[AthleticsScheduleViewController alloc] initWithSport:_sport andKey:_key andGender:_gender];
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
