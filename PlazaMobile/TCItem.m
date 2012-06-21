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
@synthesize author = _author;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _serverID = [coder decodeObjectForKey:@"serverID"];
        _title = [coder decodeObjectForKey:@"title"];
        _bodyHTML = [coder decodeObjectForKey:@"bodyHTML"];
        _tags = [coder decodeObjectForKey:@"tags"];
        _URL = [coder decodeObjectForKey:@"URL"];
		_author = [coder decodeObjectForKey:@"author"];
        _createdAt = [coder decodeObjectForKey:@"createdAt"];
        _updatedAt = [coder decodeObjectForKey:@"updatedAt"];
    }
	
    return self;
}

- (NSDate *)sortDate
{
	return self.createdAt;
}

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
//	NSLog(@"dictionary: %@", dictionary);
	
	_title = [dictionary objectForKey:@"title"];
	_bodyHTML = [dictionary objectForKey:@"body"];
	_tags = [dictionary objectForKey:@"tags"];
	_URL = [NSURL URLWithString:[dictionary objectForKey:@"short_url"]];
	_author = [[dictionary objectForKey:@"user"] objectForKey:@"long_name"];
	_createdAt = [self _dateWithServerString:[dictionary objectForKey:@"created_at"]];
	_updatedAt = [self _dateWithServerString:[dictionary objectForKey:@"updated_at"]];
}

- (NSDate *)_dateWithServerString:(NSString *)serverString
{
	static NSDateFormatter *dateFormatter = nil;
	@synchronized(self) {
		if (dateFormatter == nil) {
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
		}
	}
	
	serverString = [serverString stringByReplacingCharactersInRange:NSMakeRange(serverString.length - 3, 1) withString:@""];
	return [dateFormatter dateFromString:serverString];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:self.serverID forKey:@"serverID"];
	[coder encodeObject:self.title forKey:@"title"];
	[coder encodeObject:self.bodyHTML forKey:@"bodyHTML"];
	[coder encodeObject:self.tags forKey:@"tags"];
	[coder encodeObject:self.URL forKey:@"URL"];
	[coder encodeObject:self.author forKey:@"author"];
	[coder encodeObject:self.createdAt forKey:@"createdAt"];
	[coder encodeObject:self.updatedAt forKey:@"updatedAt"];
}

- (BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[self class]]) {
		return [self.serverID isEqual:((TCItem *)object).serverID];
	}
	
	return NO;
}

- (NSUInteger)hash
{
	return [self.serverID hash] ^ ([self.serverID hash] >> 8);
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: tuid = %@, title = %@, tags = %@, createdAt = %@, updatedAt = %@>", NSStringFromClass([self class]), self.serverID, self.title, self.tags, self.createdAt, self.updatedAt];
}

@end
