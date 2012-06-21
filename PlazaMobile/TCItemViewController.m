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
	
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
		dateFormatter.doesRelativeDateFormatting = YES;
	}
	
	_html = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"item" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*body\\s*%>" withString:_item.bodyHTML options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*title\\s*%>" withString:_item.title options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*URL\\s*%>" withString:[_item.URL description] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*createdOn\\s*%>" withString:[dateFormatter stringFromDate:_item.createdAt] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
	_html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*author\\s*%>" withString:_item.author options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
    
    
    if ([_item isKindOfClass:[TCEvent class]]) {
        TCEvent *event = (TCEvent *)_item;
        
        
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*if\\s+event\\s*%>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*end\\s+event\\s*%>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        
        
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*street\\s*%>" withString:[event.address objectForKey:TCEventAddressStreetKey] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*city\\s*%>" withString:[event.address objectForKey:TCEventAddressCityKey] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*state\\s*%>" withString:[event.address objectForKey:TCEventAddressStateKey] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*zipcode\\s*%>" withString:[event.address objectForKey:TCEventAddressZipKey] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*start_time\\s*%>" withString:[NSDateFormatter localizedStringFromDate:event.startOn dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*end_time\\s*%>" withString:[NSDateFormatter localizedStringFromDate:event.endOn dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        weekdayFormatter.dateFormat = @"EEEE";
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*day_of_the_week\\s*%>" withString:[weekdayFormatter stringFromDate:event.endOn] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
        _html = [_html stringByReplacingOccurrencesOfString:@"<%\\s*date\\s*%>" withString:[NSDateFormatter localizedStringFromDate:event.endOn dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle] options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, _html.length)];
    } else {
        static NSRegularExpression *stripIf = nil;
        if (stripIf == nil) {
            stripIf = [NSRegularExpression regularExpressionWithPattern:@"<%\\s*if\\s+event\\s*%>.*<%\\s*end\\s+event\\s*%>" options:NSRegularExpressionDotMatchesLineSeparators error:NULL];
        }
        
        _html = [stripIf stringByReplacingMatchesInString:_html options:NSCaseInsensitiveSearch range:NSMakeRange(0, _html.length) withTemplate:@""];
    }
    
	
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


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"action"]) {
        if ([request.URL.resourceSpecifier isEqualToString:@"add-event"]) {
            [self _addEvent];
        }
        
        return NO;
    }
    
    if (navigationType != UIWebViewNavigationTypeOther) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}


#pragma mark - EKEventEditViewDelegate

- (void)_addEvent
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    TCEvent *eventItem = (TCEvent *)self.item;
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = eventItem.title;
    event.startDate = eventItem.startOn;
    event.endDate = eventItem.endOn;
    event.location = [NSString stringWithFormat:@"%@\n%@, %@ %@", [eventItem.address objectForKey:TCEventAddressStreetKey], [eventItem.address objectForKey:TCEventAddressCityKey], [eventItem.address objectForKey:TCEventAddressStateKey], [eventItem.address objectForKey:TCEventAddressZipKey]];
    event.URL = eventItem.URL;
    event.notes = eventItem.body;
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    EKEventEditViewController *eventController = [[EKEventEditViewController alloc] init];
    eventController.event = event;
    eventController.eventStore = eventStore;
    eventController.editViewDelegate = self;
    [self presentModalViewController:eventController animated:YES];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
