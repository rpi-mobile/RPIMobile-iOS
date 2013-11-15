//
//  WebViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/2/13.
//  Copyright (c) 2013 Stephen Silber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong) IBOutlet UIWebView *webView;
@property (strong) NSURLRequest *firstRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url;

@end
