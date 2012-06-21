//
//  TCItemViewController.h
//  PlazaMobile
//
//  Created by David Beck on 5/3/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCItem;


@interface TCItemViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) TCItem *item;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
