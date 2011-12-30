//
//  SimpleBrowser.h
//  Frink
//
//  Created by Justin Beckwith on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface SimpleBrowser : PGPlugin<UIWebViewDelegate> {
	UIWebView* myWebView;
}

@property (nonatomic, retain) UIWebView* myWebView;

- (void)createSimpleBrowser:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)hide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)resize:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
