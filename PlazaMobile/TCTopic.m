//
//  TCTopic.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCTopic.h"
#import "TCItem_Private.h"
#import "TCPlazaController.h"

@implementation TCTopic

@synthesize comments = _comments;

- (id)_initWithDictionary:(NSDictionary *)dictionary
{
	id existing = [[TCPlazaController sharedController] itemWithServerID:[dictionary objectForKey:@"tuid"]];
	if (existing != nil) {
		[existing _updateWithDictionary:dictionary];
		return existing;
	}
	
    self = [super _initWithDictionary:dictionary];
    if (self != nil) {
		_serverID = [dictionary objectForKey:@"tuid"];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _comments = [coder decodeObjectForKey:@"comments"];
    }
	
    return self;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
	
	_comments = [dictionary objectForKey:@"posts"];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:self.comments forKey:@"comments"];
}

@end
