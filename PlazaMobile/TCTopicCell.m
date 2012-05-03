//
//  TCTopicCell.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCTopicCell.h"

#import "PlazaKit.h"


@implementation TCTopicCell

@synthesize item = _item;

@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;

- (void)setItem:(TCItem *)item
{
	_item = item;
	
	self.titleLabel.text = _item.title;
	
	NSString *body = _item.bodyHTML;
	body = [body stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, body.length)];
	body = [body stringByReplacingOccurrencesOfString:@"\\s+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, body.length)];
	self.detailLabel.text = body;
	
	CGRect detailFrame = self.detailLabel.frame;
	detailFrame.size.width = self.bounds.size.width - detailFrame.origin.x - 20.0;
	self.detailLabel.frame = detailFrame;
	
	[self.detailLabel sizeToFit];
	
	detailFrame = self.detailLabel.frame;
	detailFrame.size.height = MIN(detailFrame.size.height, self.bounds.size.height - detailFrame.origin.y - 5.0);
	self.detailLabel.frame = detailFrame;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
