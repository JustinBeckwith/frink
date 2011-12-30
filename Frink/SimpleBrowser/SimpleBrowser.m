//
//  SimpleBrowser.m
//  Frink
//
//  Created by Justin Beckwith on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleBrowser.h"

@implementation SimpleBrowser
@synthesize myWebView;



-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (SimpleBrowser*)[super initWithWebView:theWebView];
    return self;
}

- (void) createSimpleBrowser:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{	
    // read position arguments and set the view frame
	CGFloat x = [[arguments objectAtIndex:1] floatValue];
    CGFloat y = [[arguments objectAtIndex:2] floatValue];
    CGFloat w = [[arguments objectAtIndex:3] floatValue];
    CGFloat h = [[arguments objectAtIndex:4] floatValue];
	CGRect viewRect = CGRectMake(x, y, w, h); 
    
    // create the webView component
	self.myWebView = [[UIWebView alloc] initWithFrame:viewRect];
    myWebView.delegate = self;   
    myWebView.scalesPageToFit = YES;
    
    // navigate to the appropriate url
    NSString *url = (NSString*) [arguments objectAtIndex:0];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [myWebView loadRequest:request];
    
    // add the component to the main view and display it
    [self.webView.superview addSubview:myWebView];
    myWebView.hidden = NO;
}

- (void) hide:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    myWebView.hidden = YES;
}

- (void) resize:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    // read position arguments and set the view frame
	CGFloat x = [[arguments objectAtIndex:0] floatValue];
    CGFloat y = [[arguments objectAtIndex:1] floatValue];
    CGFloat w = [[arguments objectAtIndex:2] floatValue];
    CGFloat h = [[arguments objectAtIndex:3] floatValue];
	CGRect viewRect = CGRectMake(x, y, w, h); 
    
    myWebView.frame = viewRect;
}

@end
