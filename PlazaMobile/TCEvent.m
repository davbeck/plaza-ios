//
//  TCEvent.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCEvent.h"
#import "TCItem_Private.h"
#import "TCPlazaController.h"

@implementation TCEvent

@synthesize startOn = _startOn;
@synthesize endOn = _endOn;

- (NSDate *)sortDate
{
	return self.startOn;
}

- (id)_initWithDictionary:(NSDictionary *)dictionary
{
	id existing = [[TCPlazaController sharedController] itemWithServerID:[dictionary objectForKey:@"euid"]];
	if (existing != nil) {
		[existing _updateWithDictionary:dictionary];
		return existing;
	}
	
    self = [super _initWithDictionary:dictionary];
    if (self != nil) {
		_serverID = [dictionary objectForKey:@"euid"];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _startOn = [coder decodeObjectForKey:@"startOn"];
        _endOn = [coder decodeObjectForKey:@"endOn"];
    }
	
    return self;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:self.startOn forKey:@"startOn"];
	[coder encodeObject:self.endOn forKey:@"endOn"];
}

@end
