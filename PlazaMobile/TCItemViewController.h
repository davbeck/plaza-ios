//
//  TCItemViewController.h
//  PlazaMobile
//
//  Created by David Beck on 5/3/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@class TCItem;


@interface TCItemViewController : UIViewController <UIWebViewDelegate, EKEventEditViewDelegate>

@property (nonatomic, strong) TCItem *item;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
