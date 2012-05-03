//
//  TCNeed.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCNeed.h"
#import "TCItem_Private.h"
#import "TCPlazaController.h"

@implementation TCNeed

- (id)_initWithDictionary:(NSDictionary *)dictionary
{
	id existing = [[TCPlazaController sharedController] itemWithServerID:[dictionary objectForKey:@"nuid"]];
	if (existing != nil) {
		[existing _updateWithDictionary:dictionary];
		return existing;
	}
	
    self = [super _initWithDictionary:dictionary];
    if (self != nil) {
		_serverID = [dictionary objectForKey:@"nuid"];
    }
	
    return self;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
}

@end
