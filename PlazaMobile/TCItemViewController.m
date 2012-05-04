//
//  TCItemViewController.m
//  PlazaMobile
//
//  Created by David Beck on 5/3/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCItemViewController.h"

#import "PlazaKit.h"


@interface TCItemViewController ()

@end


@implementation TCItemViewController {
	NSString *_html;
}

@synthesize item = _item;

@synthesize webView = _webView;

- (void)setItem:(TCItem *)item
{
	_item = item;
	
	_html = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"item" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*body\\s*%>" withString:_item.bodyHTML options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*title\\s*%>" withString:_item.title options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*URL\\s*%>" withString:[_item.URL description] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*createdOn\\s*%>" withString:[_item.createdAt description] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*author\\s*%>" withString:_item.author options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	
	[self.webView loadHTMLString:_html baseURL:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.webView loadHTMLString:_html baseURL:nil];
}

- (void)viewDidUnload
{
	[self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
