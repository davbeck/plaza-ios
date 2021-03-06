//
//  TCTopicCell.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCTopicCell.h"

#import "PlazaKit.h"
#import <QuartzCore/QuartzCore.h>


@implementation TCTopicCell

@synthesize item = _item;

@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize typeIconView = _typeIconView;

@synthesize weekdayLabel = _weekdayLabel;
@synthesize dayLabel = _dayLabel;

- (void)setItem:(TCItem *)item
{
	_item = item;
	
	self.titleLabel.text = _item.title;
	
	NSString *body = _item.bodyHTML;
	body = [body stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, body.length)];
	body = [body stringByReplacingOccurrencesOfString:@"\\s+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, body.length)];
	self.detailLabel.text = body;
	
	CGRect detailFrame = self.detailLabel.frame;
	detailFrame.size.width = (self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width) - detailFrame.origin.x;
	self.detailLabel.frame = detailFrame;
	
	[self.detailLabel sizeToFit];
	
	detailFrame = self.detailLabel.frame;
	detailFrame.size.height = MIN(detailFrame.size.height, self.bounds.size.height - detailFrame.origin.y - 5.0);
	self.detailLabel.frame = detailFrame;
	
	
	if ([_item isKindOfClass:[TCTopic class]]) {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_topic.png"];
	} else if ([_item isKindOfClass:[TCEvent class]]) {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_event.png"];
	} else if ([_item isKindOfClass:[TCPrayer class]]) {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_prayer.png"];
	} else if ([_item isKindOfClass:[TCNeed class]]) {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_need.png"];
	} else if ([_item isKindOfClass:[TCAlbum class]]) {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_album.png"];
	} else {
		self.typeIconView.image = [UIImage imageNamed:@"plaza_topic.png"];
	}
	
	
	if ([_item isKindOfClass:[TCEvent class]]) {
		static NSDateFormatter *weekdayFormatter = nil;
		if (weekdayFormatter == nil) {
			weekdayFormatter = [[NSDateFormatter alloc] init];
			weekdayFormatter.dateFormat = @"EEEE";
		}
		static NSDateFormatter *dayFormatter = nil;
		if (dayFormatter == nil) {
			dayFormatter = [[NSDateFormatter alloc] init];
			dayFormatter.dateFormat = @"d";
		}
		
		TCEvent *event = (TCEvent *)_item;
		
		self.weekdayLabel.text = [weekdayFormatter stringFromDate:event.startOn];
		self.dayLabel.text = [dayFormatter stringFromDate:event.startOn];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

@end
