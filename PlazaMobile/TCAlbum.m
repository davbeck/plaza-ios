//
//  TCAlbum.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCAlbum.h"
#import "TCItem_Private.h"
#import "TCPlazaController.h"

@implementation TCAlbum

- (id)_initWithDictionary:(NSDictionary *)dictionary
{
	id existing = [[TCPlazaController sharedController] itemWithServerID:[dictionary objectForKey:@"auid"]];
	if (existing != nil) {
		[existing _updateWithDictionary:dictionary];
		return existing;
	}
	
    self = [super _initWithDictionary:dictionary];
    if (self != nil) {
		_serverID = [dictionary objectForKey:@"auid"];
    }
	
    return self;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
}

- (NSString *)description
{
	NSString *description = [super description];
	NSString *subDescription = [NSString stringWithFormat:@""];
	
	return [description stringByReplacingCharactersInRange:NSMakeRange(description.length - 1, 0) withString:subDescription];
}

@end
