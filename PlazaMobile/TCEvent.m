//
//  TCEvent.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCEvent.h"
#import "TCItem_Private.h"

@implementation TCEvent

@synthesize startOn = _startOn;
@synthesize endOn = _endOn;

- (NSDate *)sortDate
{
	return self.startOn;
}

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
	
	_serverID = [dictionary objectForKey:@"euid"];
}

@end
