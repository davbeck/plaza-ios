//
//  TCItem.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCItem.h"
#import "TCItem_Private.h"

@implementation TCItem

@synthesize serverID = _serverID;
@synthesize title = _title;
@synthesize bodyHTML = _bodyHTML;
@synthesize tags = _tags;
@synthesize URL = _URL;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;

- (id)_initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self _updateWithDictionary:dictionary];
    }
	
    return self;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	NSLog(@"dictionary: %@", dictionary);
	
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
	}
	
	_title = [dictionary objectForKey:@"title"];
	_bodyHTML = [dictionary objectForKey:@"body"];
	_tags = [dictionary objectForKey:@"tags"];
	_URL = [dictionary objectForKey:@"short_url"];
	_createdAt = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
	_updatedAt = [dateFormatter dateFromString:[dictionary objectForKey:@"updated_at"]];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Item: tuid = %@, title = %@, tags = %@, createdAt = %@, updatedAt = %@>", self.serverID, self.title, self.tags, self.createdAt, self.updatedAt];
}

@end
