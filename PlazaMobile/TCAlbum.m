//
//  TCAlbum.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCAlbum.h"
#import "TCItem_Private.h"

@implementation TCAlbum

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
	
	_serverID = [dictionary objectForKey:@"auid"];
}

- (NSString *)description
{
	NSString *description = [super description];
	NSString *subDescription = [NSString stringWithFormat:@""];
	
	return [description stringByReplacingCharactersInRange:NSMakeRange(description.length - 1, 0) withString:subDescription];
}

@end
