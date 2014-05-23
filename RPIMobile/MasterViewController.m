//
//  RMMasterViewController.m
//  Rollio Mobile
//
//  Created by Rocco Del Priore on 5/10/14.
//  Copyright (c) 2014 Rollio. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterMenuObject.h"
#import "MasterMenuCell.h"

@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize _viewControllers, _navController;

#pragma mark - Initialzers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = [NSNumber numberWithInt:1];
	
    //Create Views
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(-100, 0, 100, self.view.frame.size.height)];
    _dimView = [[UIButton alloc] initWithFrame:self.view.frame];
    
    //Set View Attributes
    [_dimView setBackgroundColor:[UIColor blackColor]];
    [_dimView setAlpha:0];
    [_dimView addTarget:self action:@selector(slideOut) forControlEvents:UIControlEventTouchDown];
    [_controlView setBackgroundColor:[UIColor whiteColor]];
    
    //Add Views
    [self.view addSubview:_dimView];
    [self.view addSubview:_controlView];
    [self.view bringSubviewToFront:_controlView];
    
    //Create TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _controlView.frame.size.width, _controlView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    [_controlView addSubview:_tableView];
}

#pragma mark - View Handling

- (void)slideOut {
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.2 animations:^(void) {
        [_controlView setFrame:CGRectMake(-100, 0, _controlView.frame.size.width, _controlView.frame.size.height)];
        _dimView.alpha = 0;
    }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [self.view removeFromSuperview];
         }
     }];
}

- (void)slideIn {
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.2 animations:^(void) {
        [_controlView setFrame:CGRectMake(0, 0, _controlView.frame.size.width, _controlView.frame.size.height)];
        _dimView.alpha = .5;
    }];
}

- (void)show {
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    [_navController.view addSubview:self.view];
    [self slideIn];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94.666666667;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [index intValue]) {
        [self slideOut];
    }
    else {
        [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:[index intValue] inSection:0] animated:YES];
        index = [NSNumber numberWithInt:indexPath.row];
        [_navController setViewControllers:[NSArray arrayWithObject:[(MasterMenuObject *)[_viewControllers objectAtIndex:[index intValue]] viewController]]];
        [self slideOut];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterMenuCell *cell = nil;
    cell = [[MasterMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"viewCell"];

    cell.menuObject = (MasterMenuObject *)[_viewControllers objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == [index intValue]) {
        [cell setSelected:TRUE];
    }
    
    return cell;
}

@end