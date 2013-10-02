//
//  WebViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (strong) IBOutlet UIToolbar *toolBar;
@property (strong) NSURLRequest *firstRequest;

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
