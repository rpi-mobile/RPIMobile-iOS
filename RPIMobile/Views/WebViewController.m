//
//  WebViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "CRToolBar.h"
#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (strong) IBOutlet CRToolBar *toolBar;


@end

@implementation WebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _firstRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    return self;
}

- (void) setTitle:(NSString *)title {
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    [self.webView loadRequest:_firstRequest];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, _toolBar.frame.size.height, 0);
    [_toolBar setBarTintColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.850]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
